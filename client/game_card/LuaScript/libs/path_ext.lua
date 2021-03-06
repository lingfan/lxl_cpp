
path = path or {}

function path.combine(...)
    local ret = ""
    local is_first = true
    for _, v in ipairs({...}) do
        if is_first then
            is_first = false
            ret = string.rtrim(tostring(v), "\\/")
        else
            ret = ret .. "/" .. string.ltrim(tostring(v), "\\/")
        end
    end
    ret = string.gsub(ret, "\\", "/")
    return ret
end