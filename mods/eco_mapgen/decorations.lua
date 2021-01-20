
local decorations = {}

function eco_mapgen.register_decoration(deco_def)
	table.insert(decorations, deco_def)
end

function eco_mapgen.render_decorations(mapblock_pos, info, height, biome)
	for _, deco_def in ipairs(decorations) do
		if type(deco_def.render) == "function" then
			deco_def.render(mapblock_pos, info, height, biome)
		end
	end
end
