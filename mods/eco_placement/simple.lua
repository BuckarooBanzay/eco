

-- simple mapblock schematic placement
function eco_placement.place_simple(def)
	return {
		on_use = eco_placement.on_use_preview(def.description),

		on_secondary_use = function(itemstack, player)
			-- build
			local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)
			if mapblock_pos then
				local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
				mapblock_lib.deserialize(mapblock_pos, def.eco.schematic, {
					use_cache = true
				})

				mapblock_data.building = {
					name = def.name
				}

				-- write data back
				mapblock_lib.set_mapblock_data(mapblock_pos, mapblock_data)

				itemstack:take_item()
				return itemstack
			else
				minetest.chat_send_player(player:get_player_name(), "Too far away")
			end
		end
	}
end
