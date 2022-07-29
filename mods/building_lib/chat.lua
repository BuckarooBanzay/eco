
minetest.register_chatcommand("building_place", {
	func = function(name, building_name)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
        local building_def = building_lib.buildings[building_name]
        if not building_def then
            return false, "building not found: '" .. building_name .. "'"
        end

        local t0 = minetest.get_us_time()
        local success, err = building_lib.do_build(mapblock_pos, building_def, function() end)
        local diff = minetest.get_us_time() - t0
        if success then
            return true, "Placement took " .. diff .. " us"
        else
            return false, err
        end
	end
})

minetest.register_chatcommand("building_check", {
	func = function(name, building_name)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
        local building_def = building_lib.buildings[building_name]
        if not building_def then
            return false, "building not found: '" .. building_name .. "'"
        end

        return building_lib.can_build(mapblock_pos, building_def)
	end
})

minetest.register_chatcommand("building_info", {
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local ppos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(ppos)
        local data = building_lib.store:get(mapblock_pos)
        return true, "Data for mapblock " .. minetest.pos_to_string(mapblock_pos) .. ": " .. dump(data)
    end
})