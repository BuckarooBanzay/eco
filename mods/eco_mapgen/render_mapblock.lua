

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

	if biome and biome.cache[info.type] and biome.cache[info.type][info.rotation] then
		biome.cache[info.type][info.rotation](mapblock_pos)
	end
end
