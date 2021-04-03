function eco_checks.mapgen_type(mapgen_type)
    return function(mapblock_pos)
        local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
        local mapgen_info = mapblock_data and mapblock_data.mapgen_info

        return mapgen_info and mapgen_type == mapgen_info.type
    end
end