building_lib.register_condition({
    name = "on_solid_underground",
    can_build = function(mapblock_pos)
        local mapblock_pos_below = vector.add(mapblock_pos, {x=0, y=-1, z=0})
        local mapgen_info_below = eco_mapgen.get_info(mapblock_pos_below)
        if not mapgen_info_below.solid then
            return false, "not on solid underground"
        else
            return true
        end
    end
})

building_lib.register_condition({
    name = "on_slope",
    can_build = function(mapblock_pos)
        local mapgen_info = eco_mapgen.get_info(mapblock_pos)
        if not mapgen_info.slope then
            return false, "landscape not sloped"
        else
            return true
        end
    end
})

building_lib.register_condition({
    name = "on_biome",
    can_build = function(mapblock_pos, _, biome_name)
		local biome = eco_mapgen.get_biome(mapblock_pos)
        if biome and biome_name == biome.name then
            return true
        else
            return false, "biome not supported"
        end
    end
})

building_lib.register_condition({
    name = "not_on_biome",
    can_build = function(mapblock_pos, _, biome_name)
		local biome = eco_mapgen.get_biome(mapblock_pos)
        if not biome or biome_name ~= biome.name then
            return true
        else
            return false, "biome not supported"
        end
    end
})

building_lib.register_condition({
    name = "on_group",
    can_build = function(mapblock_pos, _, group)
        local mapblock_pos_below = vector.add(mapblock_pos, {x=0, y=-1, z=0})
        local groups = building_lib.get_groups_at_pos(mapblock_pos_below)
        if groups[group] then
            return true
        else
            return false, "group not found: '" .. group .. "'"
        end
    end
})

local below_neighbor_support_offsets = {
	{x=0, y=-1, z=0},
	{x=1, y=-1, z=0},
	{x=-1, y=-1, z=0},
	{x=0, y=-1, z=1},
	{x=0, y=-1, z=-1},
}

building_lib.register_condition({
    name = "near_support",
    can_build = function(mapblock_pos)
        for _, offset in ipairs(below_neighbor_support_offsets) do
            local offset_mapblock_pos = vector.add(mapblock_pos, offset)
            local groups = building_lib.get_groups_at_pos(offset_mapblock_pos)
            if groups.support then
                return true
            end
        end
        return false, "not near a support structure"
    end
})
