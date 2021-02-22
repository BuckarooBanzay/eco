
local function show_preview(player, def, building_def)
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

	mapblock_lib.display_mapblock(mapblock_pos, def.description, 2)
end



minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_items) do
		if def.eco then
			assert(def.eco.place_building, "eco.place_building not found in " .. name)

			local building_def = building_lib.buildings[def.eco.place_building]
			assert(building_def, "place_building not found for " .. def.eco.place_building)
			assert(building_lib.placements[building_def.placement], "placement not found for " .. building_def.placement)

			minetest.override_item(name, {
				on_use = function(_, player)
					show_preview(player, def, building_def)
				end,
				on_secondary_use = function(itemstack, player)
					local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)
					if mapblock_pos and building_lib.do_build(mapblock_pos, building_def) then
						itemstack:take_item()
						return itemstack
					end
				end
			})
		end
	end
end)
