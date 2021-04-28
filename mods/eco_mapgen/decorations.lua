
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

local angles = {0, 90, 180, 270}


function eco_mapgen.render_decorations(mapblock_pos, info, biome_data, biome)
	for _, deco_def in ipairs(decorations) do
		if type(deco_def.match) == "table" then
			local is_match = check_match(deco_def.match, mapblock_pos, info, biome_data, biome)
			if is_match then
				local schematic

				if type(deco_def.schematics) == "table" then
					schematic = deco_def.schematics[math.random(#deco_def.schematics)]
				elseif type(deco_def.schematics) == "string" then
					schematic = deco_def.schematics
				else
					-- invalid deco def
					return
				end

				local options = {
					use_cache = true,
					mode = "add"
				}

				if not deco_def.disable_rotation then
					options.transform = {
						rotate = {
							axis = "y",
							angle = angles[math.random(#angles)]
						}
					}
				end

				mapblock_lib.deserialize(mapblock_pos, schematic, options)
				return
			end
		end
	end
end
