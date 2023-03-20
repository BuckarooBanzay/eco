
local cardinal_directions_below = {
    {x=1,y=-1,z=0},
    {x=-1,y=-1,z=0},
    {x=0,y=-1,z=1},
    {x=0,y=-1,z=-1},
    {x=0,y=-1,z=0}
}

building_lib.register_condition("support_below", {
    can_build = function(mapblock_pos)
        for _, dir in ipairs(cardinal_directions_below) do
            local offset_pos = vector.add(mapblock_pos, dir)
            local building_info = building_lib.get_placed_building_info(offset_pos)
            if building_info then
                local building_def = building_lib.get_building(building_info.name)
                if building_def and building_def.groups and building_def.groups.support then
                    return true
                end
            end
        end
		return false
	end
})

local cardinal_directions_flat = {
    {x=1,y=0,z=0},
    {x=2,y=0,z=0},
    {x=-1,y=0,z=0},
    {x=-2,y=0,z=0},
    {x=0,y=0,z=1},
    {x=0,y=0,z=2},
    {x=0,y=0,z=-1},
    {x=0,y=0,z=-2}
}

building_lib.register_condition("near_group_flat", {
    can_build = function(mapblock_pos, value)
        for _, dir in ipairs(cardinal_directions_flat) do
            local offset_pos = vector.add(mapblock_pos, dir)
            local building_info = building_lib.get_placed_building_info(offset_pos)
            if building_info then
                local building_def = building_lib.get_building(building_info.name)
                if building_def and building_def.groups and building_def.groups[value] then
                    return true
                end
            end
        end
		return false
	end
})

-- empty or group match
building_lib.register_condition("empty_or_group", {
    can_build = function(mapblock_pos, value)
        local building_def = building_lib.get_building_def_at(mapblock_pos)
        if not building_def then
            -- empty
            return true
        end
		if building_def and building_def.groups and building_def.groups[value] then
            -- group match
			return true
		end
		return false
    end
})