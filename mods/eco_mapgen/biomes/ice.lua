local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome({
	name = "ice",
	match = {
		temperature = 0,
		humidity = 20,
		min_height = 8
	},
	catalog = MP .."/schematics/mapgen_grass.zip",

	replace = {
		["eco:grass"] = "eco:ice",
		["eco:slope_grass"] = "eco:slope_ice",
		["eco:slope_grass_inner_cut"] = "eco:slope_ice_inner_cut",
		["eco:slope_grass_outer_cut"] = "eco:slope_ice_outer_cut"
	}
})
