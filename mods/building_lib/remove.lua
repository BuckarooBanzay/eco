
function building_lib.can_remove(mapblock_pos)
    local building_info, origin = building_lib.get_placed_building_info(mapblock_pos)
    if not building_info then
        return false, "no building found"
    end

    local building_def = building_lib.get_building(building_info.name)
    if not building_def then
        return false, "unknown building"
    end

    if building_def.remove_conditions then
        -- check removal conditions
        local size = building_info.size or {x=1, y=1, z=1}
        local mapblock_pos2 = vector.add(origin, vector.subtract(size, 1))
        local success, message = building_lib.check_condition_groups(
            origin, mapblock_pos2, building_def.remove_conditions
        )
        if not success then
            return false, message
        end
    end

    return true
end

function building_lib.remove(mapblock_pos, playername)
    local success, err = building_lib.can_remove(mapblock_pos)
    if not success then
        return success ,err
    end

    local building_info, origin = building_lib.get_placed_building_info(mapblock_pos)
    local size = building_info.size or {x=1, y=1, z=1}

    for x=origin.x,origin.x+size.x-1 do
        for y=origin.y,origin.y+size.y-1 do
            for z=origin.z,origin.z+size.z-1 do
                local offset_mapblock_pos = {x=x, y=y, z=z}
                -- clear building data
                building_lib.store:set(offset_mapblock_pos, nil)
                -- remove mapblock
                mapblock_lib.clear_mapblock(offset_mapblock_pos)
            end
        end
    end

    building_lib.fire_event("removed", {
        mapblock_pos = origin,
        playername = playername,
        building_info = building_info
    })
    return true
end