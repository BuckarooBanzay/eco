-- go over all items and register eco functions if the definition is found
minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_items) do
		if def.eco then
			if def.eco.mode == "simple" then
				minetest.override_item(name, eco_placement.place_simple(def))
			elseif def.eco.mode == "connected_rotate" then
				minetest.override_item(name, eco_placement.place_connected_rotate(def))
			end
		end
	end
end)

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
