
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

local function match_connections(mapblock_pos, connection)
	local other_groups = building_lib.get_groups(mapblock_pos)
	for _, group in ipairs(connection.groups or {}) do
		if not other_groups[group] then
			-- one of the required groups not found
			return false
		end
	end

	return true
end

local function select_tile(mapblock_pos, building_def)
	local default_tilepos, default_tile

	-- try to match a tile
	for tile_pos, tile in pairs(building_def.tiles) do
		local success = building_lib.check_conditions(mapblock_pos, tile.ground_conditions, building_def)
		print(dump({
			name = "select_tile::pairs(building_def.tiles)",
			tile_pos = tile_pos,
			success = success
		}))
		if not success then
			break
		end

		if tile.default then
			print({
				name = "default-tile",
				default_tilepos = default_tilepos
			})
			default_tilepos = string_to_pos(tile_pos)
			default_tile = tile
		end

		for _, rotation in ipairs(tile.rotations or {0,90,180,270}) do
			local connections = rotate_connections(tile.connections, rotation)
			for dir, connection in pairs(connections) do
				local other_pos = vector.add(mapblock_pos, string_to_pos(dir))
				local matches = match_connections(other_pos, connection)
				print(dump({
					name = "select_tile::ipairs(tile.rotations)",
					tile_pos = tile_pos,
					matches = matches,
					other_pos = other_pos
				}))

				if matches then
					return string_to_pos(tile_pos), tile
				end
			end
		end
	end

	-- fallback to default tile, if available
	return default_tilepos, default_tile, 0
end

building_lib.register_placement("connected", {
	check = function(_, mapblock_pos, building_def)
		if building_lib.get_building_at_pos(mapblock_pos) then
			return false, "already occupied"
		end

		local _, tile = select_tile(mapblock_pos, building_def)
		print(dump({
			name = "check",
			tile = tile,
		})) --XXX

		return tile ~= nil
	end,
	get_size = function(_, mapblock_pos, building_def)
		local _, tile = select_tile(mapblock_pos, building_def)
		return tile.size or { x=1, y=1, z=1 }
	end,
	place = function(_, mapblock_pos, building_def, callback)
		local tile_pos, tile, rotation = select_tile(mapblock_pos, building_def)
		print(dump({
			name = "place",
			tile_pos = tile_pos,
			tile = tile,
			rotation = rotation
		})) --XXX

		local catalog = mapblock_lib.get_catalog(building_def.catalog)
		catalog:deserialize(tile_pos, mapblock_pos, { callback = callback })

		callback()
	end
})
