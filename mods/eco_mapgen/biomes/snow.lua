local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome({
	name = "snow",
	match = {
		temperature = 20,
		humidity = 20,
		min_height = 7
	},
	catalog = MP .."/schematics/mapgen_grass.zip",
	replace = {
		["eco:grass"] = "eco:snow",
		["eco:slope_grass"] = "eco:slope_snow",
		["eco:slope_grass_inner_cut"] = "eco:slope_snow_inner_cut",
		["eco:slope_grass_outer_cut"] = "eco:slope_snow_outer_cut"
	}
})
