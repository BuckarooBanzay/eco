
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
		local timeout = 2
		local playername = player:get_player_name()
		local pos = get_pointed_nodepos(player)
		if pos then
			-- check previous click
			local previous_pos = last_pos[playername]
			if previous_pos and (previous_pos.time + timeout) > os.time() then
				-- clicked 5 seconds ago
				local distance = vector.distance(eco_util.get_mapblock(pos), previous_pos.mapblock)

				if distance < 1 then
					-- build here
					local schema_dir = minetest.get_modpath("eco_streets") .. "/schematics/street_all_sides"
					local min = eco_util.get_mapblock_bounds(pos)
					eco_serialize.deserialize(min, schema_dir)
					last_pos[playername] = nil
					return itemstack
				end
			end

			eco_util.display_mapblock_at_pos(pos, "Something, something", timeout)
			last_pos[playername] = {
				mapblock = eco_util.get_mapblock(pos),
				time = os.time()
			}
		end
		return itemstack
	end,
	on_secondary_use = function(itemstack, player)
		eco_placement.show_placement_formspec(player:get_player_name())
		--itemstack:get_meta():set_string("description", "abc")
		return itemstack
	end
})
