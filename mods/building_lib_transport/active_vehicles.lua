
-- "{mapblock_pos}/{path_name}" -> { name, speed }
local active_vehicles = {}

function building_lib_transport.format_key(mapblock_pos, path_name)
    return minetest.pos_to_string(mapblock_pos) .. "/" .. path_name
end

function building_lib_transport.parse_key(key)
    local pos_str, path_name = string.match(key, "^([^/]+)/(.*)$")
    return minetest.string_to_pos(pos_str), path_name
end

function building_lib_transport.place_vehicle(name, mapblock_pos, path_name)
    if not building_lib_transport.get_vehicle(name) then
        return nil, "no such vehicle"
    end

    if building_lib_transport.get_active_vehicle(mapblock_pos, path_name) then
        return nil, "already occupied"
    end

    local active_vehicle = {
        name = name,
        speed = 0,
        last_update = os.time(),
        next_update = os.time(),
        -- duplicated info for lookups
        mapblock_pos = mapblock_pos,
        path_name = path_name
    }

    -- place in inactive store
    local data = building_lib_transport.store:get(mapblock_pos)
    if not data.vehicles then
        data.vehicles = {}
    end

    data.vehicles[path_name] = active_vehicle
    building_lib_transport.store:set(mapblock_pos, data)

    return active_vehicle
end

function building_lib_transport.update_vehicle(vehicle)
    -- TODO
end

function building_lib_transport.remove_vehicle(vehicle)
    -- remove from active store
    local key = building_lib_transport.format_key(vehicle.mapblock_pos, vehicle.path_name)
    if active_vehicles[key] then
        active_vehicles[key] = nil
        return
    end

    -- remove from inactive store
    local data = building_lib_transport.store:get(vehicle.mapblock_pos)
    if not data.vehicles then
        return
    end

    data.vehicles[vehicle.path_name] = nil
    building_lib_transport.store:set(vehicle.mapblock_pos, data)
end

function building_lib_transport.get_active_vehicle(mapblock_pos, path_name)
    -- check active vehicles
    local active_vehicle = active_vehicles[building_lib_transport.format_key(mapblock_pos, path_name)]

    if not active_vehicle then
        -- check inactive vehicles
        local data = building_lib_transport.store:get(mapblock_pos)
        if data and data.vehicles and data.vehicles[path_name] then
            return data.vehicles[path_name]
        end
    end
end

function building_lib_transport.move_active_vehicles()
    local now = os.time()
    for _, active_vehicle in pairs(active_vehicles) do
        if active_vehicle.next_update < now then
            -- update pending
            -- TODO

            active_vehicle.last_update = now
        end
    end
end