
---@class ZoneSettingService: ServiceBase
ZoneSettingService = ZoneSettingService or class("ZoneSettingService", ServiceBase)

function ZoneSettingService:ctor(service_mgr, service_name)
    ZoneSettingService.super.ctor(self, service_mgr, service_name)
    self._watch_path = nil
    self._zone_setting_watcher = nil
    self._event_binder = EventBinder:new()

    self._etcd_client = nil
end

function ZoneSettingService:_on_init()
    ZoneSettingService.super:_on_init(self)
    local etcd_setting = self.server.etcd_service_discovery_setting
    self._watch_path = string.format(Zone_Setting_Svc_Const.db_path_zone_setting_format, self.server.zone)
    self._zone_setting_watcher = EtcdWatcher:new(etcd_setting.host, etcd_setting.user, etcd_setting.pwd, self._watch_path)
    self._event_binder:bind(self._zone_setting_watcher, Etcd_Watch_Event.watch_content_change, Functional.make_closure(self._on_zone_setting_change, self))

    self._etcd_client = EtcdClient:new(etcd_setting.host, etcd_setting.user, etcd_setting.pwd)
end

function ZoneSettingService:_on_start()
    ZoneSettingService.super._on_start(self)
    self._zone_setting_watcher:start()
end

function ZoneSettingService:_on_stop()
    ZoneSettingService.super._on_stop(self)
    self._zone_setting_watcher:stop()
end

function ZoneSettingService:_on_release()
    ZoneSettingService.super._on_release(self)
end

function ZoneSettingService:_on_update()
    ZoneSettingService.super._on_update(self)

    local now_sec = logic_sec()
    if not self._last_set_sec or now_sec - self._last_set_sec > 5 then
        self._last_set_sec = now_sec
        if math.random() > 0.5 then
            self._etcd_client:set(string.format("%s/r_%s", self._watch_path, math.random(1, 10)),
                    math.random(), math.random(10, 20))
        else
            self._etcd_client:set(string.format("%s/s_%s/t_%s", self._watch_path, math.random(1, 10),
                    math.random(20, 30)), math.random(), math.random(10, 20))
        end
    end

    -- for test
    --[[
    local client = self:create_rpc_client(self.server:get_cluster_server_key())
    client:call(function (rpc_error_num, ...)
        -- log_print("remote call callback ", rpc_error_num, ...)
    end, "hello", "world")
    ]]
end

function ZoneSettingService:_on_zone_setting_change(etcd_watcher)
    log_print("ZoneSettingService:_on_zone_setting_change")
end
