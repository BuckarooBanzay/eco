
local function get_pointed_nodepos(player)
	local raybegin = vector.add(player:get_pos(),{x=0, y=player:get_properties().eye_height, z=0})
	local rayend = vector.add(raybegin, vector.multiply(player:get_look_dir(), 100))
	local ray = minetest.raycast(raybegin, rayend, true, false)
	ray:next() -- player

	local pointed_thing = ray:next()

	if not pointed_thing then
		return
	end

	if pointed_thing.type == "node" then
		return pointed_thing.above
	end
end

local last_pos = {}

minetest.register_craftitem("eco_placement:wand", {
	description = "Placement wand",
	inventory_image = "eco_placement_wand.png",
	range = 0,
	on_use = function(itemstack, player)
		local meta = itemstack:get_meta()
		local build_type = meta:get_string("build_type")
		local build_key = meta:get_string("build_key")
		local description = meta:get_string("description") or ""
		local size_x = meta:get_int("size_x") or 1
		local size_z = meta:get_int("size_z") or 1

		if not build_type or not build_key then
			minetest.chat_send_player(player:get_player_name(), "Wand unconfigured, use 'right-click' to select a building")
			return itemstack
		end

		local timeout = 2
		local playername = player:get_player_name()
		local pos = get_pointed_nodepos(player)
		if pos then
			local mapblock = eco_util.get_mapblock(pos)
			local info = eco_mapgen.get_info(mapblock)

			-- check previous click
			local previous_pos = last_pos[playername]
			if previous_pos and (previous_pos.time + timeout) > os.time() then
				-- clicked 5 seconds ago
				local distance = vector.distance(mapblock, previous_pos.mapblock)

				if distance < 1 then
					-- build here
					if build_type == "street" then
						eco_placement.place_street(mapblock, build_key, true)
					elseif build_type == "building" then
						eco_placement.place_building(mapblock, build_key)
					end

					last_pos[playername] = nil
					return itemstack
				end
			end

			local is_occupied = false
			for x=1,size_x do
				for z=1,size_z do
					local check_pos = eco_util.get_mapblock(pos)
					check_pos.x = check_pos.x + (x - 1)
					check_pos.z = check_pos.z + (z - 1)
					local extended_grid = eco_grid.get_mapblock(check_pos)

					if extended_grid and extended_grid.type then
						is_occupied = true
						break
					end
				end
			end

			if is_occupied then
				eco_util.display_mapblock_at_pos(pos, "Already occupied!", timeout)

			elseif info.type == "flat" or info.type == "slope" then

				-- show all affected mapblocks
				for x=1,size_x do
					for z=1,size_z do
						local show_pos = eco_util.get_mapblock(pos)
						show_pos.x = show_pos.x + (x - 1)
						show_pos.z = show_pos.z + (z - 1)

						eco_util.display_mapblock(show_pos, description, timeout)
					end
				end

				-- remember selection for next click
				last_pos[playername] = {
					mapblock = eco_util.get_mapblock(pos),
					time = os.time()
				}

			else
				eco_util.display_mapblock_at_pos(pos, "Can't build here, terrain not suitable!", timeout)

			end

		end
		return itemstack
	end,
	on_secondary_use = function(itemstack, player)
		eco_placement.show_placement_formspec(player:get_player_name())
		--itemstack:get_meta():set_string("description", "abc")
		return itemstack
	end
})
