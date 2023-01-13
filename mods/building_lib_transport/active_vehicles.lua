
-- table with keys pointing to mapblocks that have moving vehicles in it
-- hash(mapblock_pos) -> true
local active_mapblocks = {}

-- TODO: persist in mod_storage

-- sets or removes the active mapblock entry
local function set_active_mapblock_flag(mapblock_pos)
    -- check current mapblock for moving vehicles
    local hash = minetest.hash_node_position(mapblock_pos)
    active_mapblocks[hash] = false
    local vehicles = building_lib_transport.get_mapblock_vehicles(mapblock_pos)
    for _, v in pairs(vehicles) do
        if v.speed > 0 then
            -- mark as active
            active_mapblocks[hash] = true
        end
    end
end

-- placement / removal / query

function building_lib_transport.remove_active_vehicle(vehicle)
    local vehicles = building_lib_transport.get_mapblock_vehicles(vehicle.mapblock_pos)
    vehicles[vehicle.path_name] = nil
    building_lib_transport.set_mapblock_vehicles(vehicle.mapblock_pos, vehicles)
    set_active_mapblock_flag(vehicle.mapblock_pos)
end

-- TODO: remove all vehicles in a mapblock

function building_lib_transport.get_active_vehicle(mapblock_pos, path_name)
    local vehicles = building_lib_transport.get_mapblock_vehicles(mapblock_pos)
    return vehicles[path_name]
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
        position = 0,
        last_update = os.time(),
        next_update = os.time(),
        -- duplicated info for lookups
        mapblock_pos = mapblock_pos,
        path_name = path_name
    }

    local vehicles = building_lib_transport.get_mapblock_vehicles(mapblock_pos)
    vehicles[path_name] = active_vehicle
    building_lib_transport.set_mapblock_vehicles(mapblock_pos, vehicles)

    return active_vehicle
end

-- movement / update functions

function building_lib_transport.update_active_vehicle(vehicle)
    set_active_mapblock_flag(vehicle.mapblock_pos)
end

function building_lib_transport.move_active_vehicles()
    for hash in pairs(active_mapblocks) do
        local mapblock_pos = minetest.get_position_from_hash(hash)
        local vehicles = building_lib_transport.get_mapblock_vehicles(mapblock_pos)
        -- TODO: move stuff
    end
end