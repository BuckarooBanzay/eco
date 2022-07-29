
-- local decorations = {}


local biomes = {}

function eco_mapgen.register_biome(def)
	assert(def.name)
	biomes[def.name] = def
end

function eco_mapgen.get_biomes()
    return biomes
end