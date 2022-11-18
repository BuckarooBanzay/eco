
local cardinal_directions = {
    {x=1,y=-1,z=0},
    {x=-1,y=-1,z=0},
    {x=0,y=-1,z=1},
    {x=0,y=-1,z=-1},
    {x=0,y=-1,z=0}
}

building_lib.register_condition("near_support", {
    can_build = function(mapblock_pos)
        for _, dir in ipairs(cardinal_directions) do
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
