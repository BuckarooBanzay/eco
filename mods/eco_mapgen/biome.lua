
eco_mapgen.biomes = {}

function eco_mapgen.register_biome(name, def)
	def.name = name
	eco_mapgen.biomes[name] = def
end

function eco_mapgen.get_biome(mapblock_pos, info, height)
	for key, biome in pairs(eco_mapgen.biomes) do
		if biome.match(mapblock_pos, info, height) then
			return biome, key
		end
	end
end
