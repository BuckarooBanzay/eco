
local function get_angle(direction)
	-- slope looks into z+ (normal slope) or x-/z+ (diagonal slope) direction
	if direction == "z-" or direction == "x+z-" then
		return 180
	elseif direction == "x+" or direction == "x+z+" then
		return 90
	elseif direction == "x-" or direction == "x-z-" then
		return 270
	else
		return 0
	end
end

function eco_mapgen.render_mapblock(mapblock_pos)
	local info = eco_mapgen.get_info(mapblock_pos)
	local biome_data = eco_mapgen.get_biome_data(mapblock_pos)
	local biome = eco_mapgen.get_biome(mapblock_pos, info, biome_data)

	-- add mapgen info (if available) to grid data
	if info.type ~= "none" then
		-- only save if data available
		mapblock_lib.set_mapblock_data(mapblock_pos, {
			mapgen_info = info
		})
	end

	if biome and biome.cache[info.type] then
		local angle = get_angle(info.direction)
		if biome.cache[info.type][angle] then
			biome.cache[info.type][angle](mapblock_pos)
		end
	end
end
