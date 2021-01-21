
-- returns the mapblock the player points to
function eco_placement.get_pointed_mapblock_pos(player)
	local raybegin = vector.add(player:get_pos(),{x=0, y=player:get_properties().eye_height, z=0})
	local rayend = vector.add(raybegin, vector.multiply(player:get_look_dir(), 100))
	local ray = minetest.raycast(raybegin, rayend, true, false)
	ray:next() -- player

	local pointed_thing = ray:next()

	if not pointed_thing then
		return
	end

	if pointed_thing.type == "node" and pointed_thing.above then
		return mapblock_lib.get_mapblock(pointed_thing.above)
	end
end

-- preview mapblock on_use
function eco_placement.on_use_preview(description)
	return function(_, player)
		-- preview
		local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)
		if mapblock_pos then
			mapblock_lib.display_mapblock(mapblock_pos, description, 2)
		else
			minetest.chat_send_player(player:get_player_name(), "Too far away")
		end
	end
end
