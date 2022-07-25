
eco_mapgen.biomes = {}

function eco_mapgen.register_biome(def)
	assert(def.name)
	assert(type(def.catalog) == "string")
	local catalog = mapblock_lib.get_catalog(def.catalog)
	local plain_options = {
		transform = {
			replace = def.replace
		}
	}

	-- prepare all mapblocks in the catalog with their rotations
	-- ${type}.${angle}
	local cache = {}
	cache.full = { [0] = catalog:prepare({x=0, y=0, z=0}, plain_options) }

	cache.slope = {}
	cache.slope_inner = {}
	cache.slope_outer = {}

	for _, angle in ipairs({0,90,180,270}) do
		local options = {
			transform = {
				rotate = {
					axis = "y",
					angle = angle
				},
				replace = def.replace
			}
		}
		cache.slope[angle] = catalog:prepare({x=2,y=0,z=0}, options)
		cache.slope_inner[angle] = catalog:prepare({x=1,y=0,z=0}, options)
		cache.slope_outer[angle] = catalog:prepare({x=3,y=0,z=0}, options)
	end

	def.cache = cache
	eco_mapgen.biomes[def.name] = def
end

local function get_score(biome, mapblock_pos, biome_data)
	local score = 0

	if biome.match.min_height and mapblock_pos.y < biome.match.min_height then
		return
	end
	if biome.match.temperature then
		score = score - math.abs(biome_data.temperature - biome.match.temperature)
	end
	if biome.match.humidity then
		score = score - math.abs(biome_data.humidity - biome.match.humidity)
	end

	return score
end

function eco_mapgen.get_biome(mapblock_pos, info, biome_data)
	info = info or eco_mapgen.get_info(mapblock_pos)
	biome_data = biome_data or eco_mapgen.get_biome_data(mapblock_pos)

	local selected_biome
	local selected_score

	for _, biome in pairs(eco_mapgen.biomes) do
		if type(biome.match) == "function" and biome.match(mapblock_pos, info, biome_data.height) then
			-- hard-wired match() function, return fast
			return biome
		elseif type(biome.match) == "table" then
			-- matching table, evaluate
			local score = get_score(biome, mapblock_pos, biome_data)

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
