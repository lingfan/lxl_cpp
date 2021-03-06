

RpcRsp = RpcRsp or class("RpcRsp")

function RpcRsp:ctor(id, from_host, from_id, rpc_mgr)
    self.id = id
    self.from_host = from_host
    self.from_id = from_id
    self.rpc_mgr = rpc_mgr
    self.co = nil
    -- self.call_fn_params = nil
    -- self.call_fn_params_count = nil
    self.delay_execute_fns = {}
end

function RpcRsp:respone(...)
    -- self.rpc_mgr:respone(self.id, self.from_host, self.from_id, Rpc_Const.Action_Return_Result, ...)
    self:send_back(Rpc_Const.Action_Return_Result, ...)
end

function RpcRsp:report_error(error_str)
    -- self.rpc_mgr:respone(self.id, self.from_host, self.from_id, Rpc_Const.Action_Report_Error, error_str)
    self:send_back(Rpc_Const.Action_Report_Error, error_str)
end

function RpcRsp:postpone_expire()
    -- self.rpc_mgr:respone(self.id, self.from_host, self.from_id, Rpc_Const.Action_PostPone_Expire)
    self:send_back(Rpc_Const.Action_PostPone_Expire)
end

function RpcRsp:add_delay_execute(fn)
    table.insert(self.delay_execute_fns, fn)
end

function RpcRsp:send_back(rpc_action, ...)
    self.rpc_mgr:respone(self.id, self.from_host, self.from_id, rpc_action, ...)
end

function RpcRsp:create_rpc_client()
    assert(self.from_host)
    assert(self.rpc_mgr)
    local client = create_rpc_client(self.rpc_mgr, self.from_host)
    return client
end