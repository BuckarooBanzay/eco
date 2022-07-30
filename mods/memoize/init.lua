
local pack = function (...) return { ... } end

memoize = function(fn, key_fn)
    local cache = {}

    return function(...)
        local key = key_fn(...)
        if not cache[key] then
            cache[key] = pack(fn(...))
        end
        return unpack(cache[key])
    end
end