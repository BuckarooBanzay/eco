
minetest.register_chatcommand("building_place", {
	func = function(name, building_name)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
        local building_def = building_lib.buildings[building_name]
        if not building_def then
            return false, "building not found: '" .. building_name .. "'"
        end

        return building_lib.do_build(mapblock_pos, building_def)
	end
})
