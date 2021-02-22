minetest.override_item("", {
	on_use = function()
		print("on_use")
	end,
	on_secondary_use = function(_, player)
		print("on_secondary_use")
		local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)
		if mapblock_pos then
			mapblock_lib.display_mapblock(mapblock_pos, minetest.pos_to_string(mapblock_pos), 4)
			local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
			print(dump(mapblock_pos), dump(mapblock_data))
		end
	end
})
