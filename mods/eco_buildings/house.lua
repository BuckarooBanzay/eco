local MP = minetest.get_modpath("eco_buildings")

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

minetest.register_craftitem("eco_buildings:house", {
	description = "Simple house",
	inventory_image = "default_mese_crystal.png",
	on_use = function(_, player)
		-- preview
		local pos = get_pointed_nodepos(player)
		if pos then
			local mapblock_pos = mapblock_lib.get_mapblock(pos)
			mapblock_lib.display_mapblock(mapblock_pos, "House", 2)
		else
			minetest.chat_send_player(player:get_player_name(), "Too far away")
		end
	end,

	on_secondary_use = function(itemstack, player)
		-- build
		local pos = get_pointed_nodepos(player)
		if pos then
			local mapblock_pos = mapblock_lib.get_mapblock(pos)
			mapblock_lib.deserialize(mapblock_pos, MP .. "/schematics/house", {
				use_cache = true
			})
			itemstack:take_item()
			return itemstack
		else
			minetest.chat_send_player(player:get_player_name(), "Too far away")
		end
	end

})
