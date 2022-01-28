local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome({
	name = "ice",
	match = {
		temperature = 0,
		humidity = 20,
		min_height = 8
	},

	flat = MP .. "/schematics/base/grass_flat",

	slope_upper = MP .. "/schematics/base/grass_slope_upper",
	slope_lower = MP .. "/schematics/base/grass_slope_lower",

	slope_inner_upper = MP .."/schematics/base/grass_slope_inner_corner_upper",
	slope_inner_lower = MP .."/schematics/base/grass_slope_inner_corner_lower",

	slope_outer_upper = MP .."/schematics/base/grass_slope_outer_corner_upper",
	slope_outer_lower = MP .."/schematics/base/grass_slope_outer_corner_lower",

	replace = {
		["eco:grass"] = "default:ice",
		["eco:slope_grass"] = "moreblocks:slope_ice",
		["eco:slope_grass_inner_cut"] = "moreblocks:slope_ice_inner_cut",
		["eco:slope_grass_outer_cut"] = "moreblocks:slope_ice_outer_cut"
	}
})
