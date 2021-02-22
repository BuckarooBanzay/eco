

local function is_connected(mapblock_pos, name)
	local building_def = building_lib.get_building_at_pos(mapblock_pos)
	return building_def and building_def.name == name
end


local function place_street(name, mapblock_pos, schematics)
	local mapblock_pos_upper = { x=mapblock_pos.x, y=mapblock_pos.y+1, z=mapblock_pos.z }
	local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
	local mapgen_info = mapblock_data.mapgen_info

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
		local neighbor_building_def = building_lib.get_building_at_pos(neighbor_mapblock)
		if neighbor_building_def and neighbor_building_def.name == name then
			place_street(name, neighbor_mapblock, schematics)
		end
	end
end


building_lib.register_placement({
	name = "connected",
	check = function(mapblock_pos)
		if building_lib.get_building_at_pos(mapblock_pos) then
			return false, "already occupied"
		end
		return true
	end,
	place = function(mapblock_pos, building_def)
		place_street(building_def.name, mapblock_pos, building_def.schematics)
		update_neighbor_streets(building_def.name, mapblock_pos, building_def.schematics)
	end
})
