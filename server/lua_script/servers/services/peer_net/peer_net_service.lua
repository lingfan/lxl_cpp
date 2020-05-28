
---@class PeerNetService: ServiceBase
PeerNetService = PeerNetService or class("PeerNetService", ServiceBase)

function PeerNetService:ctor(service_mgr, service_name)
    PeerNetService.super.ctor(self, service_mgr, service_name)
    self._listen_handler = nil
    self._next_unique_id = make_sequence(0)

    self._unique_id_to_cnn_states = {}

    self._cluster_state = {
        is_joined = false,
        server_states = {}
    }
end

function PeerNetService:_on_init()
    self._event_binder:bind(self.server, Discovery_Service_Event.cluster_join_state_change,
            Functional.make_closure(self._on_event_cluster_join_state_change, self))
    self._event_binder:bind(self.server, Discovery_Service_Event.cluster_server_change,
            Functional.make_closure(self._on_event_cluster_server_change, self))
end

function PeerNetService:_on_start()
    PeerNetService.super._on_start(self)
    self.listen_handler = NetListen:new()
    self.listen_handler:set_gen_cnn_cb(Functional.make_closure(PeerNetService._make_accept_cnn, self))
    local advertise_peer_port = tonumber(self.server.init_setting.advertise_peer_port)
    local ret = Net.listen("0.0.0.0", advertise_peer_port, self.listen_handler)
    if not ret then
        self._error_num = -1
        self._error_msg = string.format("PeerNetService listen advertise_peer_port=%s fail", advertise_peer_port)
    else
        log_info("PeerNetService listen advertise_peer_port %s", advertise_peer_port)
    end
end

function PeerNetService:_on_stop()
    PeerNetService.super._on_stop(self)
end

function PeerNetService:_on_update()
    PeerNetService.super._on_update(self)
    local now_sec = logic_sec()
    if nil == self._connect_server_last_sec or now_sec - self._connect_server_last_sec > 5 then
        self._connect_server_last_sec = now_sec
        self:_connect_server(self.server.discovery:get_self_server_key())
    end
end

function PeerNetService:_on_event_cluster_join_state_change(is_joined)
    self._cluster_state.is_joined = is_joined
end

function PeerNetService:_on_event_cluster_server_change(action, old_server_data, new_server_data)
    local server_key = old_server_data and old_server_data.key or new_server_data.key
    local server_state = self._cluster_state.server_states[server_key]
    if not server_state then
        server_state = {
            server_key = server_key,
            server_data = nil,
            cnn_unique_id = nil
        }
        self._cluster_state.server_states[server_key] = server_state
    end

    if Discovery_Service_Const.cluster_server_join == action then
        server_state.server_data = new_server_data
    end
    if Discovery_Service_Const.cluster_server_leave == action then
        server_state.server_data = nil
    end
    if Discovery_Service_Const.cluster_server_change == action then
        server_state.server_data = new_server_data
    end
    if server_state.cnn_unique_id then
        self:_close_cnn(server_state.cnn_unique_id)
        server_state.cnn_unique_id = nil
    end
end

function PeerNetService:_make_accept_cnn(listen_handler)
    local unique_id = self._next_unique_id()
    local cnn = PidBinCnn:new()
    cnn:set_open_cb(Functional.make_closure(PeerNetService._on_accept_cnn_open, self, unique_id))
    cnn:set_close_cb(Functional.make_closure(PeerNetService._on_accept_cnn_close, self, unique_id))
    cnn:set_recv_cb(Functional.make_closure(PeerNetService._on_accept_cnn_recv_msg, self, unique_id))

    self._unique_id_to_cnn_states[unique_id] = {
        unique_id = unique_id,
        cnn = cnn,
        cnn_type = Peer_Net_Const.accept_cnn_type,
        server_key = nil,
        server_data = nil,
        is_ok = false, -- nil:悬而未决，true:可用, false:不可用
        recv_msg_counts = 0,
        error_num = nil,
        cnn_async_id = nil,
        cached_pid_bins = {} -- 缓存的数据
    }
    return cnn
end

function PeerNetService:_connect_server(server_key)
    if not self._cluster_state.is_joined then
        return nil
    end
    local server_state = self._cluster_state.server_states[server_key]
    if not server_state or not server_state.server_data then
        return nil
    end
    if not server_state.cnn_unique_id then
        local server_data = server_state.server_data
        local cnn, unique_id = self:_make_peer_cnn()
        local cnn_async_id = Net.connect_async(server_data.data.advertise_peer_ip, server_data.data.advertise_peer_port, cnn)
        self._unique_id_to_cnn_states[unique_id] = {
            unique_id = unique_id,
            cnn = cnn,
            cnn_type = Peer_Net_Const.peer_cnn_type,
            server_key = server_state.server_key,
            server_data = server_data,
            is_ok = false,
            error_num = nil,
            error_msg = nil,
            cnn_async_id = cnn_async_id,
        }
        server_state.cnn_unique_id = unique_id
    end

    return server_state.cnn_unique_id
end

function PeerNetService:_make_peer_cnn()
    local unique_id = self._next_unique_id()
    local cnn = PidBinCnn:new()
    cnn:set_open_cb(Functional.make_closure(PeerNetService._on_peer_cnn_open, self, unique_id))
    cnn:set_close_cb(Functional.make_closure(PeerNetService._on_peer_cnn_close, self, unique_id))
    cnn:set_recv_cb(Functional.make_closure(PeerNetService._on_peer_cnn_recv_msg, self, unique_id))
    return cnn, unique_id
end

function PeerNetService:_close_cnn(unique_id)
    local cnn_state = self._unique_id_to_cnn_states[unique_id]
    self._unique_id_to_cnn_states[unique_id] = nil
    if cnn_state then
        if cnn_state.cnn then
            cnn_state.cnn:reset()
        end
        if cnn_state.server_key then
            local server_state = self._cluster_state.server_states[cnn_state.server_key]
            if server_state then
                server_state.cnn_unique_id = nil
            end
        end
        if cnn_state.cnn_async_id then
            Net.cancel_async(cnn_state.cnn_async_id)
        end
        -- todo:应该还有协议缓存队列
    end
end

function PeerNetService:_disconnect_server(server_key)
    local server_state = self._cluster_state.server_states[server_key]
    if server_state and server_state.cnn_unique_id  then
        self:_close_cnn(server_state.cnn_unique_id)
        server_state.cnn_unique_id = nil
    end
end
