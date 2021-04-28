
local decorations = {}

function eco_mapgen.register_decoration(deco_def)
	table.insert(decorations, deco_def)
end

local function check_match(match, mapblock_pos, info, _, biome)
	if match.biome and match.biome ~= biome.name then
		return false
	end

	if match.mapgen_type and match.mapgen_type ~= info.type then
		return false
	end

	if match.min_height and mapblock_pos.y < match.min_height then
		return false
	end

	if match.chance and match.chance ~= math.random(match.chance) then
		return false
	end

	return true
end

function eco_mapgen.render_decorations(mapblock_pos, info, biome_data, biome)
	for _, deco_def in ipairs(decorations) do
		if type(deco_def.match) == "table" and type(deco_def.render) == "function" then
			local is_match = check_match(deco_def.match, mapblock_pos, info, biome_data, biome)
			if is_match then
				deco_def.render(mapblock_pos)
			end
		end
	end
end
