building_lib.register_condition({
    name = "on_flat_surface",
    can_build = function(mapblock_pos)
        local mapgen_info = eco_mapgen.get_info(mapblock_pos)
        local mapgen_matches = mapgen_info and mapgen_info.type == "flat"
        if not mapgen_matches then
            return false, "landscape not flat"
        else
            return true
        end
    end
})

building_lib.register_condition({
    name = "on_slope_lower",
    can_build = function(mapblock_pos)
        local mapgen_info = eco_mapgen.get_info(mapblock_pos)
        local mapgen_matches = mapgen_info and mapgen_info.type == "slope_lower"
        if not mapgen_matches then
            return false, "landscape not sloped"
        else
            return true
        end
    end
})

building_lib.register_condition({
    name = "on_biome",
    can_build = function(mapblock_pos, _, biome)
		local _, biome_name = eco_mapgen.get_biome(mapblock_pos)
        if biome_name == biome then
            return true
        else
            return false, "biome not supported"
        end
    end
})

building_lib.register_condition({
    name = "not_on_biome",
    can_build = function(mapblock_pos, _, biome)
		local _, biome_name = eco_mapgen.get_biome(mapblock_pos)
        if biome_name ~= biome then
            return true
        else
            return false, "biome not supported"
        end
    end
})
