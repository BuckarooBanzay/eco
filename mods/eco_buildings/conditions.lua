building_lib.register_condition({
    name = "on_flat_surface",
    can_build = function(mapblock_pos)
        local mapgen_info = eco_mapgen.get_info(mapblock_pos)
        local mapgen_matches = mapgen_info and mapgen_info.type == "flat"
        if not mapgen_matches then
            return false, "landscape not supported"
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
            return false, "landscape not supported"
        else
            return true
        end
    end
})
