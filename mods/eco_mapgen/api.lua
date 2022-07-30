
-- biome_name -> { top = {} }
local decorations = {}

function eco_mapgen.register_decoration(biome_name, def)
	decorations[biome_name] = decorations[biome_name] or {}
	table.insert(decorations[biome_name], def)
end

function eco_mapgen.get_decorations(biome_name)
	return decorations[biome_name] or {}
end

local biomes = {}

function eco_mapgen.register_biome(name, def)
	def.name = name
	biomes[name] = def
end

function eco_mapgen.get_biomes()
    return biomes
end
