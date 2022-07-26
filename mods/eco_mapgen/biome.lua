
eco_mapgen.biomes = {}

function eco_mapgen.register_biome(def)
	assert(def.name)
	eco_mapgen.biomes[def.name] = def
end

local function get_score(biome, biome_data)
	local score = 0

	if biome.match.temperature then
		score = score - math.abs(biome_data.temperature - biome.match.temperature)
	end
	if biome.match.humidity then
		score = score - math.abs(biome_data.humidity - biome.match.humidity)
	end

	return score
end

function eco_mapgen.get_biome(mapblock_pos, slope_info, biome_data)
	slope_info = slope_info or eco_mapgen.get_slope_info(mapblock_pos)
	biome_data = biome_data or eco_mapgen.get_biome_data(mapblock_pos)

	local selected_biome
	local selected_score

	for _, biome in pairs(eco_mapgen.biomes) do
		if type(biome.match) == "function" and biome.match(mapblock_pos, slope_info, biome_data.height) then
			-- hard-wired match() function, return fast
			return biome
		elseif type(biome.match) == "table" then
			-- matching table, evaluate
			local score = get_score(biome, biome_data)

			if score and (not selected_biome or selected_score < score) then
				-- current score higher or no biome selected at all
				selected_score = score
				selected_biome = biome
			end
		end
	end

	return selected_biome
end

minetest.register_chatcommand("biome_info", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "player not found"
		end

		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
		local biome = eco_mapgen.get_biome(mapblock_pos)

		return true, "Biome at mapblock " ..
			minetest.pos_to_string(mapblock_pos) .. ": " .. (biome and biome.name or "<none>")
	end
})
