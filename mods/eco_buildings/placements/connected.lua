
local function string_to_pos(str)
    return minetest.string_to_pos("(" .. str .. ")")
end

local function pos_to_string(pos)
    return pos.x .. "," .. pos.y .. "," .. pos.z
end

local function flip_pos(rel_pos, axis)
	rel_pos[axis] = 0 - rel_pos[axis]
end

local function transpose_pos(rel_pos, axis1, axis2)
	rel_pos[axis1], rel_pos[axis2] = rel_pos[axis2], rel_pos[axis1]
end

local function rotate_connections(connections, rotation)
    if rotation == 0 then
        return connections
    end
    local rotated_connections = {}

    for pos_str, rule in pairs(connections) do
        local pos = string_to_pos(pos_str)
        if rotation == 90 then
            flip_pos(pos, "x")
            transpose_pos(pos, "x", "z")
        elseif rotation == 180 then
            flip_pos(pos, "x")
            flip_pos(pos, "z")
        elseif rotation == 270 then
            flip_pos(pos, "z")
            transpose_pos(pos, "x", "z")
        end
        rotated_connections[pos_to_string(pos)] = rule
    end

    return rotated_connections
end

local function match_connection(mapblock_pos, connection, other_mapblock_pos, other_connections)
	if not connection then
		return false
	end

	local other_abs_pos = vector.subtract(mapblock_pos, other_mapblock_pos)

	local other_pos_str = pos_to_string(other_abs_pos)
	local other_connection = other_connections[other_pos_str]
	if not other_connection then
		return false
	end

	if other_connection ~= connection then
		return false
	end

	return true
end

local function select_tile(mapblock_pos, building_def)
	local selected_tilepos, selected_tile, selected_rotation = 0
	local selected_tile_score = 0

	-- try to match a tile
	for tile_pos, tile in pairs(building_def.tiles) do
		if tile.default and selected_tile_score == 0 then
			-- select default tile if no other available
			selected_tilepos = string_to_pos(tile_pos)
			selected_tile = tile
		end

		for _, rotation in ipairs(tile.rotations or {0}) do
			local connections = rotate_connections(tile.connections, rotation)
			local matches = true
			local num_connections = 0

			for dir, connection in pairs(connections) do
				num_connections = num_connections + 1
				local other_pos = vector.add(mapblock_pos, string_to_pos(dir))
				local other_building = building_lib.get_building_at_pos(other_pos)

				if other_building then
					if other_building.placement == "connected" then
						-- just check group
						local groups = building_lib.get_groups(mapblock_pos)
						if not groups[connection] then
							matches = false
							break
						end
					elseif other_building.placement == "simple" then
						local other_placement_options = building_lib.get_placement_options(other_pos) or {}
						local other_rotation = other_placement_options.rotation or 0
						local other_connections = rotate_connections(other_building.connections, other_rotation)

						local conn_match = match_connection(mapblock_pos, connection, other_pos, other_connections)
						if not conn_match then
							matches = false
							break
						end
					-- else
						-- unknown placement type
					end
				else
					matches = false
					break
				end
			end

			if matches and num_connections > selected_tile_score then
				selected_tilepos = string_to_pos(tile_pos)
				selected_tile = tile
				selected_rotation = rotation
				selected_tile_score = num_connections
			end
		end
	end

	-- fallback to default tile, if available
	return selected_tilepos, selected_tile, selected_rotation
end

local function select_and_place(mapblock_pos, building_def)
	local tile_pos, _, rotation = select_tile(mapblock_pos, building_def)
	if not tile_pos then
		return
	end

	local catalog = mapblock_lib.get_catalog(building_def.catalog)
	catalog:deserialize(tile_pos, mapblock_pos, {
		transform = {
			rotate = {
				axis = "y",
				angle = rotation
			}
		}
	})

	return tile_pos, rotation
end

local cardinal_directions = {
	{x=1,y=0,z=0},
	{x=-1,y=0,z=0},
	{x=0,y=0,z=1},
	{x=0,y=0,z=-1}
}

local function place_and_update(mapblock_pos, building_def)
	-- place target tile
	local tile_pos, rotation = select_and_place(mapblock_pos, building_def)

	-- update neighbors
	for _, dir in ipairs(cardinal_directions) do
		local neighbor_mapblock_pos = vector.add(mapblock_pos, dir)
		local neighbor_building = building_lib.get_building_at_pos(neighbor_mapblock_pos)
		if neighbor_building and neighbor_building.placement == "connected" then
			select_and_place(neighbor_mapblock_pos, neighbor_building)
		end
	end

	return tile_pos, rotation
end

building_lib.register_placement("connected", {
	check = function(_, mapblock_pos, building_def)
		if building_lib.get_building_at_pos(mapblock_pos) then
			return false, "already occupied"
		end

		local _, tile = select_tile(mapblock_pos, building_def)
		return tile ~= nil
	end,
	get_size = function()
		return { x=1, y=1, z=1 }
	end,
	place = function(_, mapblock_pos, building_def, placement_options, callback)
		local tile_pos, rotation = place_and_update(mapblock_pos, building_def)
		callback()
		placement_options.rotation = rotation
		placement_options.tile_pos = tile_pos
	end
})

if minetest.get_modpath("mtt") then
	mtt.register("string_to_pos", function(callback)
		assert(vector.equals(string_to_pos("1,2,3"), {x=1,y=2,z=3}))
		callback()
	end)

	mtt.register("pos_to_string", function(callback)
		assert(pos_to_string({x=1,y=2,z=3}) == "1,2,3")
		callback()
	end)

	mtt.register("rotate_connections", function(callback)
		local connections = {
			["1,0,0"] = "x+"
		}
		local rotated_connections = rotate_connections(connections, 90)
		assert(rotated_connections["0,0,-1"] == "x+")

		rotated_connections = rotate_connections(connections, 180)
		assert(rotated_connections["-1,0,0"] == "x+")

		rotated_connections = rotate_connections(connections, 270)
		assert(rotated_connections["0,0,1"] == "x+")

		callback()
	end)

	mtt.register("match_connection", function(callback)

		local mapblock_pos = {x=0,y=0,z=0}
		local connection = "myconn"

		local other_mapblock_pos = {x=1,y=0,z=0}
		local other_connections = {
			["-1,0,0"] = "myconn"
		}

		local match = match_connection(mapblock_pos, connection, other_mapblock_pos, other_connections)
		assert(match)
		callback()
	end)
end