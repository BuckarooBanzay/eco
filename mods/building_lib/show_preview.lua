function building_lib.show_preview(mapblock_pos, description, building_def)
    local size = building_lib.get_size(building_def)

    -- convert to 0-base range
    local range = vector.add(size, -1)
    for x=mapblock_pos.x, mapblock_pos.x+range.x do
        for z=mapblock_pos.z, mapblock_pos.z+range.z do
            mapblock_lib.display_mapblock({x=x, y=mapblock_pos.y, z=z}, description or "?", 2)
        end
    end
end