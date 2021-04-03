
local function check_place_on(mapblock_pos, def)
	if not def or not def.eco or not def.eco.place_on then
		return true
	end

	local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
	local mapgen_info = mapblock_data and mapblock_data.mapgen_info

	if type(def.eco.place_on) == "function" then
		-- "manual" function check
		return def.eco.place_on(mapblock_pos, mapblock_data, mapgen_info)
	end

	local info_matches = false
	if def.eco.place_on.mapgen_type and mapgen_info then
		-- check if the mapgen_type matches (slope, flat, etc)
		for _, name in ipairs(def.eco.place_on.mapgen_type) do
			if name == mapgen_info.type then
				info_matches = true
				break
			end
		end
	else
		-- no mapblock info specified
		info_matches = true
	end

	local biome_matches = false
	if def.eco.place_on.biome then
		-- check if a biome matches
		local _, biome_name = eco_mapgen.get_biome(mapblock_pos)
		if biome_name then
			for _, name in ipairs(def.eco.place_on.biome) do
				if name == biome_name then
					biome_matches = true
					break
				end
			end
		end
	else
		-- no biome specified
		biome_matches = true
	end

	if not biome_matches then
		return false, "Wrong biome"
	elseif not info_matches then
		return false, "unsuited terrain!"
	else
		return true
	end
end


local function show_preview(player, def, building_def)
	-- preview
	local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)
	if not mapblock_pos then
		minetest.chat_send_player(player:get_player_name(), "Too far away")
		return
	end

	local success, message = check_place_on(mapblock_pos, def)
	if success then
		success, message = building_lib.can_build(mapblock_pos, building_def)
	end

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
					if mapblock_pos then
						if not check_place_on(mapblock_pos, def) then
							return
						end
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
