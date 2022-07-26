local function get_slope_rotation(hm)
	if hm[-1][0] and not hm[1][0] and not hm[0][-1] and not hm[0][1] then
		return 270
	elseif not hm[-1][0] and hm[1][0] and not hm[0][-1] and not hm[0][1] then
		return 90
	elseif not hm[-1][0] and not hm[1][0] and hm[0][-1] and not hm[0][1] then
		return 180
	elseif not hm[-1][0] and not hm[1][0] and not hm[0][-1] and hm[0][1] then
		return 0
	end
end

local function get_slope_inner_rotation(hm)
	if hm[0][-1] and hm[-1][0] and not hm[0][1] and not hm[1][0] then
		return 270
	elseif not hm[0][-1] and hm[-1][0] and hm[0][1] and not hm[1][0] then
		return 0
	elseif not hm[0][-1] and not hm[-1][0] and hm[0][1] and hm[1][0] then
		return 90
	elseif hm[0][-1] and not hm[-1][0] and not hm[0][1] and hm[1][0] then
		return 180
	end
end

local function get_slope_outer_rotation(hm)
	if hm[-1][-1] and not hm[-1][1] and not hm[1][1] and not hm[1][-1] then
		return 270
	elseif not hm[-1][-1] and hm[-1][1] and not hm[1][1] and not hm[1][-1] then
		return 0
	elseif not hm[-1][-1] and not hm[-1][1] and hm[1][1] and not hm[1][-1] then
		return 90
	elseif not hm[-1][-1] and not hm[-1][1] and not hm[1][1] and hm[1][-1] then
		return 180
	end
end

local function get_height_map(mapblock_pos, mapblock_height)
	-- collect neighbor elevations and count
	local hm = {}
	for x=-1,1 do
		hm[x] = hm[x] or {}
		for z=-1,1 do
			local neighbor_height = eco_mapgen.get_biome_data({ x=mapblock_pos.x+x, z=mapblock_pos.z+z }).height

			if neighbor_height > mapblock_height then
				-- neighbor is higher
				hm[x][z] = true
			end
		end
	end

	return hm
end

local function get_slope_info(mapblock_pos)
	local height = eco_mapgen.get_biome_data(mapblock_pos).height

	-- above heightmap
	if mapblock_pos.y > height then
		return { type = "none" }
	end

	-- below heightmap
	if mapblock_pos.y < height then
		return { type = "full", rotation = 0 }
	end

	-- surface block
	if mapblock_pos.y == height then
		-- collect neighbor elevations
		local hm = get_height_map(mapblock_pos, height)

		-- straight slopes
		local rotation = get_slope_rotation(hm)
		if rotation then
			return { type = "slope", rotation = rotation }
		end

		-- z- / x- / z+ / x+
		rotation = get_slope_inner_rotation(hm)
		if rotation then
			return { type = "slope_inner", rotation = rotation }
		end

		rotation = get_slope_outer_rotation(hm)
		if rotation then
			return { type = "slope_outer", rotation = rotation }
		end

		-- no rotation
		return { type = "full", rotation = 0 }
	end
end

local cache = {}

-- cached access
function eco_mapgen.get_slope_info(mapblock_pos)
	local key = minetest.hash_node_position(mapblock_pos)
	if not cache[key] then
		cache[key] = get_slope_info(mapblock_pos)
	end

	return cache[key]
end
