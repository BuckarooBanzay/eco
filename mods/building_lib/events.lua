
-- name -> list<fn>
local events = {}

function building_lib.fire_event(name, ...)
    for _, fn in ipairs(events[name] or {}) do
        fn(...)
    end
end

function building_lib.register_on(name, fn)
    local list = events[name]
    if not list then
        list = {}
        events[name] = list
    end
    table.insert(list, fn)
end