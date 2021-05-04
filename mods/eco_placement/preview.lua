function eco_placement.show_preview(player, description, building_def)
	-- preview
	local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)
	if not mapblock_pos then
		minetest.chat_send_player(player:get_player_name(), "Too far away")
		return
	end

	local success, message = building_lib.can_build(mapblock_pos, building_def)

	if not success then
		minetest.chat_send_player(player:get_player_name(), message or "can't build here!")
		return
	end

	building_lib.show_preview(mapblock_pos, description, building_def)
end