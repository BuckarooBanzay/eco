local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome({
	name = "water",
	match = function(mapblock_pos, info)
		return mapblock_pos.y < 0 and info.type ~= "underground"
	end,
	catalog = MP .."/schematics/mapgen_grass.zip",

	replace = {
		["air"] = "eco:water_source",
		["eco:grass"] = "eco:dirt",
		["eco:stone"] = "eco:dirt",
		["eco:slope_grass"] = "eco:water_source",
		["eco:slope_grass_inner_cut"] = "eco:water_source",
		["eco:slope_grass_outer_cut"] = "eco:water_source"
	}
})
