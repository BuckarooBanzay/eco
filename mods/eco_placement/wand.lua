
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

		if not build_type or build_type == "" then
			build_type = "street"
		end

		if not build_key or build_key == "" then
			build_key = "eco_streets:dirt_road"
		end

		print(build_type, build_key) --XXX

		local timeout = 2
		local playername = player:get_player_name()
		local pos = get_pointed_nodepos(player)
		if pos then
			local mapblock = eco_util.get_mapblock(pos)
			local info = eco_mapgen.get_info(mapblock)
			local grid = eco_grid.get_mapblock(mapblock)

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

			if grid and (grid.type == "street" or grid.type == "building") then
				eco_util.display_mapblock_at_pos(pos, "Already occupied!", timeout)

			elseif info.type == "flat" or info.type == "slope" then
				-- TODO: show all mapblocks
				eco_util.display_mapblock_at_pos(pos, description, timeout)
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
