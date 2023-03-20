
local cache = {}

function building_lib.memoize(fn, keyfn)
    return function(...)
        local key = keyfn(...)
        if not cache[key] then
            cache[key] = { fn(...) }
        end
        return unpack(cache[key])
    end
end

function building_lib.memoize_invalidate(key)
    cache[key] = nil
end

-- periodic cleanup
local function purge_cache()
    cache = {}
    minetest.after(300, purge_cache)
end

minetest.after(10, purge_cache)