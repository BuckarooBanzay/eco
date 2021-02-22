local function can_build(mapblock_pos, building_def)
	if type(building_def.can_build) == "function" then
		local success, message = building_def.can_build(mapblock_pos, building_def)
		if not success then
			return success, message
		end
	end

	local placement = building_lib.placements[building_def.placement]
	local success, message = placement.check(mapblock_pos, building_def)
	if not success then
		return false, message
	end

	-- all checks ok
	return true
end

local function show_preview(player, def, building_def)
	-- preview
	local mapblock_pos = building_lib.get_pointed_mapblock_pos(player)
	if not mapblock_pos then
		minetest.chat_send_player(player:get_player_name(), "Too far away")
		return
	end

	local success, message = can_build(mapblock_pos, building_def)
	if not success then
		minetest.chat_send_player(player:get_player_name(), message or "can't build here!")
		return
	end

	mapblock_lib.display_mapblock(mapblock_pos, def.description, 2)
end

local function do_build(player, _, building_def)
	local mapblock_pos = building_lib.get_pointed_mapblock_pos(player)
	if not mapblock_pos then
		minetest.chat_send_player(player:get_player_name(), "Too far away")
		return false
	end

	local success, message = can_build(mapblock_pos, building_def)
	if not success then
		minetest.chat_send_player(player:get_player_name(), message or "can't build here!")
		return false
	end

	local placement = building_lib.placements[building_def.placement]
	placement.place(mapblock_pos, building_def)

	return true
end


minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_items) do
		if def.building_lib then
			assert(def.building_lib.place, "building_lib.place not found in " .. name)

			local building_def = building_lib.buildings[def.building_lib.place]
			assert(building_def, "building_def not found for " .. def.building_lib.place)
			assert(building_lib.placements[building_def.placement], "placement not found for " .. building_def.placement)

			minetest.override_item(name, {
				on_use = function(_, player)
					show_preview(player, def, building_def)
				end,
				on_secondary_use = function(itemstack, player)
					if do_build(player, def, building_def) then
						itemstack:take_item()
						return itemstack
					end
				end
			})
		end
	end
end)
