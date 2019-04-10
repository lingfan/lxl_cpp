
Net = Net or {}

function Net.connect(ip, port, cnn_handler)
    return native.net_connect(ip, port, cnn_handler:cnn_handler_weak_ptr())
end

function Net.listen(ip, port, listen_handler)
    return native.net_listen(ip, port, listen_handler:listen_handler_weak_ptr())
end

function Net.close(netid)
    native.net_close(netid)
end

function Net.connect_async(ip, port, cnn_handler)
    return native.net_connect_async(ip, port, cnn_handler:cnn_handler_weak_ptr())
end

function Net.listen_async(ip, port, listen_handler)
    return native.net_listen_async(ip, port, listen_handler:listen_handler_weak_ptr())
end

function Net.cancel_async(async_id)
    native.net_cancel_async(async_id)
end