
-- updates the position of an entry
local function update_position(entry, now)
    now = now or minetest.get_us_time()
    print(dump({
        fn = "update_position",
        entry = entry,
        now = now
    }))

    local building_def, origin, rotation = building_lib.get_building_def_at(entry.building_pos)
    if not building_def then
        return false, "no building found at " .. minetest.pos_to_string(entry.building_pos)
    end
    if not building_def.transport then
        return false, "building has no transport-definition"
    end

    local building_size = building_lib.get_building_size(building_def, rotation)
    local rotated_routes = eco_transport.rotate_routes(building_def.transport.routes, building_size, rotation)

    local route = rotated_routes[entry.route_name]
    if not route then
        return false, "route '" .. entry.route_name .. "' not found"
    end

    -- set start of route time if not set
    if not entry.route_start_time then
        entry.route_start_time = now
    end

    if not route.length then
        -- TODO: refactor and calculate on startup
        -- calculate route-length and store it in the route-definition itself
        route.length = eco_transport.get_route_length(route)
    end

    -- set progress in nodes
    if not entry.progress then
        -- start of the route
        entry.progress = 0
    else
        -- increment progress with current velocity
        entry.progress = entry.progress + 1
    end

    if entry.progress >= route.length then
        -- end of route
        local target_dir = eco_transport.get_connected_route_dir(route, building_size)
        local target_pos = vector.add(origin, target_dir)
        local target_building_def, _, target_rotation = building_lib.get_building_def_at(target_pos)

        if target_building_def and
            target_building_def.transport and
            target_building_def.transport.routes and
            target_rotation then

            local target_building_size = building_lib.get_building_size(target_building_def, target_rotation)
            local target_routes = target_building_def.transport.routes
            local rotated_target_routes = eco_transport.rotate_routes(target_routes, target_building_size, rotation)

            local new_route_name = eco_transport.find_connected_route(route, rotated_target_routes, target_dir)
            if new_route_name then

                print(dump({
                    fn = "new route",
                    new_route_name = new_route_name
                }))
                entry.route_name = new_route_name
                entry.progress = 0
                entry.building_pos = target_pos
                entry.route_start_time = now
            end
        end
    end

    if entry.progress >= route.length then
        -- next route not found, fix in end-position
        entry.progress = route.length
    end

    entry.last_update = now
    entry.valid_until = minetest.get_us_time() + (1000*1000)

    return true
end

-- id -> entry
-- serialized periodically / deserialized on start
local entries = {}

-- id -> true
local visible_entries = {}

function eco_transport.add_entry(entry)
    entries[entry.id] = entry
    local success, err = update_position(entry)
    if not success then
        entries[entry.id] = nil
        return false, "adding failed: " .. err
    end
    return true
end

function eco_transport.change_visibility(id, visible)
    visible_entries[id] = visible and true or nil
end

function eco_transport.is_visible(id)
    return visible_entries[id]
end

function eco_transport.get_entry(id)
    return entries[id], visible_entries[id]
end

local function move_entries()
    local now = minetest.get_us_time()
    for id, entry in pairs(entries) do
        if entry.valid_until < now then
            local success, err = update_position(entry, now)
            if not success then
                print("removing entry " .. entry.id .. " due to update_position-error: " .. err)
                entries[id] = nil
            end
        end
    end
    minetest.after(0.2, move_entries)
end

minetest.after(0.2, move_entries)