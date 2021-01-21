
function eco_placement.can_build(mapblock_pos, eco_def)
	local biome = eco_mapgen.get_biome(mapblock_pos)
	local info = eco_mapgen.get_info(mapblock_pos)

	local biome_match = true
	if eco_def.biomes and biome then
		biome_match = false
		for _, name in ipairs(eco_def.biomes) do
			if name == biome.name then
				biome_match = true
				break
			end
		end
	end

	local info_match = false
	if eco_def.place_on then
		for _, name in ipairs(eco_def.place_on) do
			if name == info.type then
				info_match = true
				break
			end
		end
	end

	return biome_match and info_match
end
