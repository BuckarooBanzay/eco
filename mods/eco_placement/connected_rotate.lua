



local function is_connected(mapblock_pos, name)
	local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
	return mapblock_data and mapblock_data.building and mapblock_data.building.name == name
end

local function place_street(name, mapblock_pos, schematics)
	local mapblock_pos_upper = { x=mapblock_pos.x, y=mapblock_pos.y+1, z=mapblock_pos.z }
	local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
	local mapgen_info = mapblock_data.mapgen_info
	local building_info = mapblock_data.building or {}

	if mapgen_info.type == "flat" then
		-- check connections on flat surface and one layer below
		local xplus = is_connected(vector.add(mapblock_pos, {x=1, y=0, z=0}), name) or
			is_connected(vector.add(mapblock_pos, {x=1, y=-1, z=0}), name)
		local xminus = is_connected(vector.add(mapblock_pos, {x=-1, y=0, z=0}), name) or
			is_connected(vector.add(mapblock_pos, {x=-1, y=-1, z=0}), name)
		local zplus = is_connected(vector.add(mapblock_pos, {x=0, y=0, z=1}), name) or
			is_connected(vector.add(mapblock_pos, {x=0, y=-1, z=1}), name)
		local zminus = is_connected(vector.add(mapblock_pos, {x=0, y=0, z=-1}), name) or
			is_connected(vector.add(mapblock_pos, {x=0, y=-1, z=-1}), name)

		local schematic = schematics.straight
		local options = {
			use_cache = true,
			transform = {
				rotate = {
					axis = "y",
					angle = 0,
					disable_orientation = {
						["default:stonebrick"] = true
					}
				}
			}
		}

		if xplus and xminus and zplus and zminus then
			-- all sides
			schematic = schematics.all_sides

		elseif not xplus and xminus and zplus and zminus then
			-- three sides 90°
			schematic = schematics.three_sides
			options.transform.rotate.angle = 90

		elseif xplus and not xminus and zplus and zminus then
			-- three sides 270°
			schematic = schematics.three_sides
			options.transform.rotate.angle = 270

		elseif xplus and xminus and not zplus and zminus then
			-- three sides 0°
			schematic = schematics.three_sides
			options.transform.rotate.angle = 0

		elseif xplus and xminus and zplus and not zminus then
			-- three sides 180°
			schematic = schematics.three_sides
			options.transform.rotate.angle = 180

		elseif xplus and not xminus and zplus and not zminus then
			-- corner 0°
			schematic = schematics.corner
			options.transform.rotate.angle = 0

		elseif not xplus and xminus and zplus and not zminus then
			-- corner 270°
			schematic = schematics.corner
			options.transform.rotate.angle = 270

		elseif xplus and not xminus and not zplus and zminus then
			-- corner 90°
			schematic = schematics.corner
			options.transform.rotate.angle = 90

		elseif not xplus and xminus and not zplus and zminus then
			-- corner 180°
			schematic = schematics.corner
			options.transform.rotate.angle = 180

		elseif xplus or xminus then
			-- straight 0°
			schematic = schematics.straight
			options.transform.rotate.angle = 0

		elseif zplus or zminus then
			-- straight 90°
			schematic = schematics.straight
			options.transform.rotate.angle = 90

		end

		mapblock_lib.deserialize(mapblock_pos, schematic, options)

	elseif mapgen_info.type == "slope_lower" then
		local options = {
			use_cache = true,
			transform = {
				rotate = {
					axis = "y",
					angle = 0
				}
			}
		}

		-- rotate (z+ is default)
		if mapgen_info.direction == "x+" then
			options.transform.rotate.angle = 90
		elseif mapgen_info.direction == "z-" then
			options.transform.rotate.angle = 180
		elseif mapgen_info.direction == "x-" then
			options.transform.rotate.angle = 270
		end

		mapblock_lib.deserialize(mapblock_pos, schematics.slope_lower, options)
		mapblock_lib.deserialize(mapblock_pos_upper, schematics.slope_upper, options)
	else
		-- not applicable
		return
	end

	building_info.name = name
	mapblock_data.building = building_info
	-- write data back
	mapblock_lib.set_mapblock_data(mapblock_pos, mapblock_data)
end


local street_neighbor_updates = {
  { x=1, y=0, z=0 },
  { x=0, y=0, z=1 },
  { x=0, y=0, z=-1 },
  { x=-1, y=0, z=0 },

  { x=1, y=1, z=0 },
  { x=0, y=1, z=1 },
  { x=0, y=1, z=-1 },
  { x=-1, y=1, z=0 },

  { x=1, y=-1, z=0 },
  { x=0, y=-1, z=1 },
  { x=0, y=-1, z=-1 },
  { x=-1, y=-1, z=0 },
}

local function update_neighbor_streets(name, mapblock_pos, schematics)
	-- iterate through possible connections
	for _, offset in ipairs(street_neighbor_updates) do
		local neighbor_mapblock = vector.add(mapblock_pos, offset)
		local mapblock_data = mapblock_lib.get_mapblock_data(neighbor_mapblock)
		local building_info = mapblock_data and mapblock_data.building
		if building_info and building_info.name == name then
			place_street(name, neighbor_mapblock, schematics)
		end
	end
end


-- place a connected and rotated schematic
function eco_placement.place_connected_rotate(def)
	return {
		on_use = eco_placement.on_use_preview(def),
		on_secondary_use = function(itemstack, player)
			-- build
			local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)
			if mapblock_pos then
				place_street(def.name, mapblock_pos, def.eco.schematics)
				update_neighbor_streets(def.name, mapblock_pos, def.eco.schematics)
				itemstack:take_item()
				return itemstack
			else
				minetest.chat_send_player(player:get_player_name(), "Too far away")
			end
		end
	}
end
