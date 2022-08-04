
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
	local default_tilepos, default_tile

	-- try to match a tile
	for tile_pos, tile in pairs(building_def.tiles) do
		if tile.default then
			default_tilepos = string_to_pos(tile_pos)
			default_tile = tile
		end

		for _, rotation in ipairs(tile.rotations or {0}) do
			local connections = rotate_connections(tile.connections, rotation)
			local matches = true
			local num_connections = 0

			for dir, connection in pairs(connections) do
				num_connections = num_connections + 1
				local other_pos = vector.add(mapblock_pos, string_to_pos(dir))
				local other_building = building_lib.get_building_at_pos(other_pos)

				print(dump({
					other_pos = other_pos,
					rotation = rotation,
					tile_pos = tile_pos
				}))

				if other_building then
					-- TODO: rotate
					local conn_match = match_connection(mapblock_pos, connection, other_pos, other_building.connections)

					print(dump({
						conn_match = conn_match,
						connection = connection,
						rotation = rotation
					}))

					if not conn_match then
						matches = false
						break
					end
				else
					break
				end
			end

			if matches and num_connections > 0 then
				return string_to_pos(tile_pos), tile, rotation
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
		return tile ~= nil
	end,
	get_size = function()
		return { x=1, y=1, z=1 }
	end,
	place = function(_, mapblock_pos, building_def, placement_options, callback)
		local tile_pos, _, rotation = select_tile(mapblock_pos, building_def)

		local catalog = mapblock_lib.get_catalog(building_def.catalog)
		catalog:deserialize(tile_pos, mapblock_pos, { callback = callback })

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