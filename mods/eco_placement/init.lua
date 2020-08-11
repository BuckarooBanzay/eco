
local function get_pointed_nodepos(player)
	local raybegin = vector.add(player:get_pos(),{x=0, y=player:get_properties().eye_height, z=0})
	local rayend = vector.add(raybegin, vector.multiply(player:get_look_dir(), 50))
	local ray = minetest.raycast(raybegin, rayend, true, false)
	ray:next() -- player

	local pointed_thing = ray:next()

	if not pointed_thing then
		return
	end

	if pointed_thing.type == "node" then
		return pointed_thing.above
	end
end

minetest.register_craftitem("eco_placement:wand", {
	description = "Placement wand",
	inventory_image = "eco_placement_wand.png",
	on_use = function(itemstack, player)
		local pos = get_pointed_nodepos(player)
		if pos then
			eco_util.display_mapblock_at_pos(pos)
		end
		return itemstack
	end
})

local player_entity_map = {}

local function placement_preview()
	for _, player in ipairs(minetest.get_connected_players()) do
		local wielded_name = player:get_wielded_item():get_name()
		local playername = player:get_player_name()
		if wielded_name == "eco_placement:wand" then
			local pos = get_pointed_nodepos(player)
			if pos then
				if player_entity_map[playername] then
					-- update
					local mapblock_center = eco_util.get_mapblock_center(pos)
					player_entity_map[playername]:set_pos(mapblock_center)
				else
					-- create
					player_entity_map[playername] = eco_util.display_mapblock_at_pos(pos)
				end
			else
				-- remove
				if player_entity_map[playername] then
					player_entity_map[playername]:remove()
					player_entity_map[playername] = nil;
				end
			end
		elseif player_entity_map[playername] then
			-- remove
			player_entity_map[playername]:remove()
			player_entity_map[playername] = nil;
		end
	end

	minetest.after(1, placement_preview)
end

minetest.after(1, placement_preview)

-- cleanup
minetest.register_on_leaveplayer(function(player)
  local playername = player:get_player_name()
	if (player_entity_map[playername]) then
		player_entity_map[playername]:remove()
	end
  player_entity_map[playername] = nil
end)
