
-- updates the position of an entry
local function update_position(entry, now)
    now = now or minetest.get_us_time()
    print(dump({
        fn = "update_position",
        entry = entry,
        now = now
    }))

    local building_def, _, rotation = building_lib.get_building_def_at(entry.building_pos)
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

    entry.last_update = now

    -- TODO: proper visibility check
    if not eco_transport.is_visible(entry.id) then
        -- calculate exact position and velocity
        local offset_pos = vector.subtract(vector.multiply(entry.building_pos, 16), 1)
        local start_pos_rel = route.points[1]
        local start_pos = vector.add(offset_pos, start_pos_rel)
        local direction = vector.direction(route.points[1], route.points[2])

        -- TODO: proper activate/deactivate lifecycle
        local entity = minetest.add_entity(start_pos, "eco_transport:" .. entry.type, entry.id)
        entity:set_velocity(direction)
        eco_transport.change_visibility(entry.id, true)
    end

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
    for _, entry in pairs(entries) do
        if entry.valid_until < now then
            update_position(entry, now)
        end
    end
    minetest.after(0.2, move_entries)
end

minetest.after(0.2, move_entries)