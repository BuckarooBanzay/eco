
eco_mapgen.biomes = {}

function eco_mapgen.register_biome(name, def)
	def.name = name
	eco_mapgen.biomes[name] = def
end

function eco_mapgen.get_biome(mapblock_pos, info, height)
	info = info or eco_mapgen.get_info(mapblock_pos)
	height = height or eco_mapgen.get_mapblock_height(mapblock_pos)

	for key, biome in pairs(eco_mapgen.biomes) do
		if biome.match(mapblock_pos, info, height) then
			return biome, key
		end
	end
end
