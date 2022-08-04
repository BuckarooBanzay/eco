
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

local function match_connection(mapblock_pos, other_mapblock_pos, connection)


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

			for dir, connection in pairs(connections) do
				local other_pos = vector.add(mapblock_pos, string_to_pos(dir))
				local other_building, other_origin = building_lib.get_building_at_pos(other_pos)
				-- TODO

				local matches = match_connection(mapblock_pos, other_pos, connection)
				print(dump({
					name = "select_tile::ipairs(tile.rotations)",
					tile_pos = tile_pos,
					matches = matches,
					other_pos = other_pos,
					rotation = rotation
				}))

				if matches then
					return string_to_pos(tile_pos), tile, rotation
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
		return tile ~= nil
	end,
	get_size = function()
		return { x=1, y=1, z=1 }
	end,
	place = function(_, mapblock_pos, building_def, placement_options, callback)
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

		placement_options.rotation = rotation
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
end