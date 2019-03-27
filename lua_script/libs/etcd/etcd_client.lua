
EtcdClient = EtcdClient or class("EtcdClient")

function EtcdClient:ctor(host)
    self.host = string.rtrim(host, "/")
end

function EtcdClient:get_host()
    return self.host
end

function EtcdClient:example_cb(id, op, result)

end

function EtcdClient:set(key, value, ttl, is_dir, cb_fn)
    local op = EtcdClientOpSet:new()
    op[EtcdConst.Key] = key
    op[EtcdConst.Value] = value
    op[EtcdConst.Ttl] = ttl
    op[EtcdConst.Dir] = is_dir and "true" or nil
    op.cb_fn = cb_fn
    return self:execute(op)
end

function EtcdClient:refresh_ttl(key, ttl, is_dir, cb_fn)
    local op = EtcdClientOpSet:new()
    op[EtcdConst.Key] = key
    op[EtcdConst.Ttl] = ttl
    op[EtcdConst.Dir] = is_dir and "true" or nil
    op[EtcdConst.PrevExist] = "true"
    op[EtcdConst.Refresh] = "true"
    op.cb_fn = cb_fn
    return self:execute(op)
end

function EtcdClient:get(key, recursive, cb_fn)
    local op = EtcdClientOpGet:new()
    op[EtcdConst.Key] = key
    op[EtcdConst.Recursive] = recursive and "true" or nil
    op.cb_fn = cb_fn
    return self:execute(op)
end

function EtcdClient:delete(key, recursive, cb_fn)
    local op = EtcdClientOpDelete:new()
    op[EtcdConst.Key] = key
    op[EtcdConst.Recursive] = recursive and "true" or nil
    op.cb_fn = cb_fn
    return self:execute(op)
end

function EtcdClient:watch(key, recursive, waitIndex, cb_fn)
    local op = EtcdClientOpGet:new()
    op[EtcdConst.Key] = key
    op[EtcdConst.Wait] = "true"
    op[EtcdConst.WaitIndex] = waitIndex
    op[EtcdConst.Recursive] = recursive and "true" or nil
    op.cb_fn = cb_fn
    return self:execute(op)
end

function EtcdClient:cmp_swap(key, prev_index, prev_value, value, cb_fn)
    local op = EtcdClientOpSet:new()
    op[EtcdConst.Key] = key
    op[EtcdConst.Value] = value
    op[EtcdConst.PrevIndex] = prev_index
    op[EtcdConst.PrevValue] = prev_value
    op.cb_fn = cb_fn
    return self:execute(op)
end

function EtcdClient:cmp_delete(key, prev_index, prev_value, recursive, cb_fn)
    local op = EtcdClientOpDelete:new()
    op[EtcdConst.Key] = key
    op[EtcdConst.PrevIndex] = prev_index
    op[EtcdConst.PrevValue] = prev_value
    op[EtcdConst.Recursive] = recursive and "true" or nil
    op.cb_fn = cb_fn
    return self:execute(op)
end

function EtcdClient:execute(op)
    return op:execute(self)
end