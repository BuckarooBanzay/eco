
local biomes = {}

function eco_mapgen.register_biome(biome_def)
  biomes[biome_def.key] = biome_def
end

function eco_mapgen.get_biome(key)
  return biomes[key]
end

function eco_mapgen.get_biomes()
  return biomes
end
