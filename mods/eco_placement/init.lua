
minetest.register_craftitem("eco_placement:wand", {
	description = "Placement wand",
	inventory_image = "eco_placement_wand.png",
	on_use = function(itemstack, player)
		local raybegin = vector.add(player:get_pos(),{x=0, y=player:get_properties().eye_height, z=0})
    local rayend = vector.add(raybegin, vector.multiply(player:get_look_dir(), 50))
    local ray = minetest.raycast(raybegin, rayend, true, false)
    ray:next() -- player

    local pointed_thing = ray:next()

    if not pointed_thing then
      return itemstack
    end

		if pointed_thing.type == "node" then
			eco_util.display_mapblock_at_pos(pointed_thing.above)
    end
		return itemstack
	end
})
