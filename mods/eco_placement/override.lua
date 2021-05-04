



minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_items) do
		if def.eco then
			assert(def.eco.place_building, "eco.place_building not found in " .. name)

			local building_def = building_lib.buildings[def.eco.place_building]
			assert(building_def, "place_building not found for " .. def.eco.place_building)
			assert(building_lib.placements[building_def.placement], "placement not found for " .. building_def.placement)

			minetest.override_item(name, {
				on_use = function(_, player)
					eco_placement.show_preview(player, def.description, building_def)
				end,
				on_secondary_use = function(itemstack, player)
					local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)
					if mapblock_pos then
						if building_lib.do_build(mapblock_pos, building_def) then
							if minetest.check_player_privs(player, "privs") then
								-- creative mode, no item consumption
								return
							else
								-- consume one item
								itemstack:take_item()
								return itemstack
							end
						end
					end
				end
			})
		end
	end
end)
