
minetest.register_chatcommand("building_place", {
	func = function(name, building_name)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)

        local t0 = minetest.get_us_time()
        local success, err = building_lib.do_build(mapblock_pos, building_name, {}, function() end)
        local diff = minetest.get_us_time() - t0
        if success then
            return true, "Placement took " .. diff .. " us"
        else
            return false, err
        end
	end
})

minetest.register_chatcommand("building_remove", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
        local origin = mapblock_pos

        local data = building_lib.store:get(mapblock_pos)
        if not data then
            return false, "no building found"
        end

        if data.building and data.building.ref then
            -- resolve link
            origin = data.building.ref
            data = building_lib.store:get(data.building.ref)
        end

        if data.building then
            local size = data.building.size
            for x=origin.x,origin.x+size.x-1 do
                for y=origin.y,origin.y+size.y-1 do
                    for z=origin.z,origin.z+size.z-1 do
                        local offset_mapblock_pos = {x=x, y=y, z=z}
                        -- clear building data
                        building_lib.store:set(offset_mapblock_pos, nil)
                        -- remove mapblock
                        mapblock_lib.clear_mapblock(offset_mapblock_pos)
                    end
                end
            end
        end

        return true, "removed '" .. data.building.name .. "'"
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