

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

				if def.eco.is_support then
					-- mark upper mapblock as "flat"
					local mapblock_pos_upper = { x=mapblock_pos.x, y=mapblock_pos.y+1, z=mapblock_pos.z }
					mapblock_lib.set_mapblock_data(mapblock_pos_upper, {
						mapgen_info = {
							type = "flat"
						}
					})
				end

				itemstack:take_item()
				return itemstack
			else
				minetest.chat_send_player(player:get_player_name(), "Too far away")
			end
		end
	}
end
