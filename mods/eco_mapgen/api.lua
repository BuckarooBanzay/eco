
--[[
local decorations = {}

function eco_mapgen.register_decoration(name, def)
end

function eco_mapgen.get_decorations(biome_name)
end
--]]

local biomes = {}

function eco_mapgen.register_biome(name, def)
	def.name = name
	biomes[name] = def
end

function eco_mapgen.get_biomes()
    return biomes
end
