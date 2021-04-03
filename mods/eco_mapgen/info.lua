local function get_slope_direction(hm)
	if hm[-1][0] and not hm[1][0] and not hm[0][-1] and not hm[0][1] then
		return "x-"
	elseif not hm[-1][0] and hm[1][0] and not hm[0][-1] and not hm[0][1] then
		return "x+"
	elseif not hm[-1][0] and not hm[1][0] and hm[0][-1] and not hm[0][1] then
		return "z-"
	elseif not hm[-1][0] and not hm[1][0] and not hm[0][-1] and hm[0][1] then
		return "z+"
	end
end

local function get_slope_inner_direction(hm)
	if hm[0][-1] and hm[-1][0] and not hm[0][1] and not hm[1][0] then
		return "x-z-"
	elseif not hm[0][-1] and hm[-1][0] and hm[0][1] and not hm[1][0] then
		return "x-z+"
	elseif not hm[0][-1] and not hm[-1][0] and hm[0][1] and hm[1][0] then
		return "x+z+"
	elseif hm[0][-1] and not hm[-1][0] and not hm[0][1] and hm[1][0] then
		return "x+z-"
	end
end

local function get_slope_outer_direction(hm)
	if hm[-1][-1] and not hm[-1][1] and not hm[1][1] and not hm[1][-1] then
		return "x-z-"
	elseif not hm[-1][-1] and hm[-1][1] and not hm[1][1] and not hm[1][-1] then
		return "x-z+"
	elseif not hm[-1][-1] and not hm[-1][1] and hm[1][1] and not hm[1][-1] then
		return "x+z+"
	elseif not hm[-1][-1] and not hm[-1][1] and not hm[1][1] and hm[1][-1] then
		return "x+z-"
	end
end

local function get_height_map(mapblock, mapblock_height)
	-- collect neighbor elevations and count
	local hm = {}
	local elevated_neighbor_count = 0
	for x=-1,1 do
		hm[x] = hm[x] or {}
		for z=-1,1 do
			local neighbor_height = eco_mapgen.get_mapblock_height({ x=mapblock.x+x, z=mapblock.z+z })

			if neighbor_height > mapblock_height then
				-- neighbor is higher
				hm[x][z] = true
				elevated_neighbor_count = elevated_neighbor_count + 1
			end
		end
	end

	return hm, elevated_neighbor_count
end

local function get_info(mapblock)
	local lower_mapblock = { x=mapblock.x, y=mapblock.y-1, z=mapblock.z }
	local height = eco_mapgen.get_mapblock_height(mapblock)

	if mapblock.y < height then
		return { type = "underground" }
	end

	if mapblock.y == height then
		-- check slopes on flat terrain
		-- collect neighbor elevations and count
		local hm, elevated_neighbor_count = get_height_map(mapblock, height)

		if elevated_neighbor_count == 0 then
			return { type = "flat" }
		end

		-- straight slopes
		local direction = get_slope_direction(hm)
		if direction then
			return { type = "slope_lower", direction = direction }
		end

		-- z- / x- / z+ / x+
		direction = get_slope_inner_direction(hm)
		if direction then
			return { type = "slope_inner_lower", direction = direction }
		end

		direction = get_slope_outer_direction(hm)
		if direction then
			return { type = "slope_outer_lower", direction = direction }
		end

		-- no direction
		return { type = "flat" }
	end

	if mapblock.y == (height + 1) then
		-- check upper slopes just one mapblock above the flat terrain

		-- collect neighbor elevations and count
		local hm = get_height_map(lower_mapblock, height)

		-- straight slopes
		local direction = get_slope_direction(hm)
		if direction then
			return { type = "slope_upper", direction = direction }
		end

		-- z- / x- / z+ / x+
		direction = get_slope_inner_direction(hm)
		if direction then
			return { type = "slope_inner_upper", direction = direction }
		end

		direction = get_slope_outer_direction(hm)
		if direction then
			return { type = "slope_outer_upper", direction = direction }
		end
	end

	return { type = "none" }
end

local cache = {}

-- cached access
function eco_mapgen.get_info(mapblock_pos)
	local key = minetest.hash_node_position(mapblock_pos)
	if not cache[key] then
		cache[key] = get_info(mapblock_pos)
	end

	return cache[key]
end
