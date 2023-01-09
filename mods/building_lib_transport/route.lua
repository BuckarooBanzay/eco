
-- returns the connections from the end-position in that mapblock
function building_lib_transport.get_connections(mapblock_pos, rel_end_pos)
    local info, origin = building_lib.get_placed_building_info(mapblock_pos)
    if not info then
        return {}
    end

    local building_def = building_lib.get_building(info.name)
    if not building_def then
        return {}
    end

    local mapblock_size = building_lib.get_building_size(building_def, info.rotation)
    local size = vector.multiply(mapblock_size, 16)

    -- rotate relative end position
    local rotated_end_pos = mapblock_lib.rotate_pos(rel_end_pos, size, info.rotation)

    -- TODO
end
