-- store vehicle data alongside the building-data for consistency

function building_lib_transport.get_mapblock_vehicles(mapblock_pos)
    local data = building_lib.store:get(mapblock_pos)
    -- return a table not matter what
    if data then
        return data.vehicles or {}
    else
        return {}
    end
end

function building_lib_transport.set_mapblock_vehicles(mapblock_pos, vehicles)
    building_lib.store:merge(mapblock_pos, {
        vehicles = vehicles
    })
end
