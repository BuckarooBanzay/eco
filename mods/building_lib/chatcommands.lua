

minetest.register_chatcommand("building_pos1", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "player not found"
		end

		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
		mapblock_lib.display_mapblock(mapblock_pos, minetest.pos_to_string(mapblock_pos), 5)
		building_lib.mapblock_positions_1[name] = mapblock_pos

		return true, "position 1 set at " .. minetest.pos_to_string(mapblock_pos)
	end
})

minetest.register_chatcommand("building_pos2", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "player not found"
		end

		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
		mapblock_lib.display_mapblock(mapblock_pos, minetest.pos_to_string(mapblock_pos), 5)
		building_lib.mapblock_positions_2[name] = mapblock_pos

		return true, "position 2 set at " .. minetest.pos_to_string(mapblock_pos)
	end
})


minetest.register_chatcommand("building_save", {
	privs = { mapblock_lib = true },
	func = function(name, params)
		local pos1 = building_lib.mapblock_positions_1[name]
		local pos2 = building_lib.mapblock_positions_2[name]

		if not pos1 or not pos2 then
			return false, "set /building_pos1 and /building_pos2 first"
		end

		if not params or params == "" then
			return false, "specify a name for the schema"
		end

		local filename = building_lib.schema_path .. "/" .. params
		building_lib.save(pos1, pos2, filename, name)

		return true, "started saving as " .. filename
	end
})

minetest.register_chatcommand("building_allocate", {
	privs = { mapblock_lib = true },
	func = function(name, params)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "player not found"
		end

		local pos1 = building_lib.mapblock_positions_1[name]
		if not pos1 then
			return false, "set /building_pos1 first"
		end

		if not params or params == "" then
			return false, "specify the schema name"
		end

		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)

		building_lib.allocate(mapblock_pos, params)
		return true
	end
})

minetest.register_chatcommand("building_load", {
	privs = { mapblock_lib = true },
	func = function(name, params)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "player not found"
		end

		local pos1 = building_lib.mapblock_positions_1[name]
		if not pos1 then
			return false, "set /building_pos1 first"
		end

		if not params or params == "" then
			return false, "specify the schema name"
		end

		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)

		local filename = building_lib.schema_path .. "/" .. params
		return building_lib.load(mapblock_pos, filename)
	end
})
