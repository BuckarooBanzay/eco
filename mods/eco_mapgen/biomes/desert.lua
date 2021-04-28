local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome({
	name = "desert_1",
	match = {
		temperature = 80,
		humidity = 20
	},

	flat = MP .. "/schematics/base/grass_flat",

	slope_upper = MP .. "/schematics/base/grass_slope_upper",
	slope_lower = MP .. "/schematics/base/grass_slope_lower",

	slope_inner_upper = MP .."/schematics/base/grass_slope_inner_corner_upper",
	slope_inner_lower = MP .."/schematics/base/grass_slope_inner_corner_lower",

	slope_outer_upper = MP .."/schematics/base/grass_slope_outer_corner_upper",
	slope_outer_lower = MP .."/schematics/base/grass_slope_outer_corner_lower",

	replace = {
		["default:dirt_with_grass"] = "default:silver_sand",
		["eco_stairsplus:slope_dirt_with_grass"] = "eco_stairsplus:slope_silver_sand",
		["eco_stairsplus:slope_dirt_with_grass_inner_cut"] = "eco_stairsplus:slope_silver_sand_inner_cut",
		["eco_stairsplus:slope_dirt_with_grass_outer_cut"] = "eco_stairsplus:slope_silver_sand_outer_cut"
	}
})

eco_mapgen.register_biome({
	name = "desert_2",
	match = {
		temperature = 85,
		humidity = 20
	},

	flat = MP .. "/schematics/base/grass_flat",

	slope_upper = MP .. "/schematics/base/grass_slope_upper",
	slope_lower = MP .. "/schematics/base/grass_slope_lower",

	slope_inner_upper = MP .."/schematics/base/grass_slope_inner_corner_upper",
	slope_inner_lower = MP .."/schematics/base/grass_slope_inner_corner_lower",

	slope_outer_upper = MP .."/schematics/base/grass_slope_outer_corner_upper",
	slope_outer_lower = MP .."/schematics/base/grass_slope_outer_corner_lower",

	replace = {
		["default:dirt_with_grass"] = "default:sand",
		["eco_stairsplus:slope_dirt_with_grass"] = "eco_stairsplus:slope_sand",
		["eco_stairsplus:slope_dirt_with_grass_inner_cut"] = "eco_stairsplus:slope_sand_inner_cut",
		["eco_stairsplus:slope_dirt_with_grass_outer_cut"] = "eco_stairsplus:slope_sand_outer_cut"
	}
})

eco_mapgen.register_biome({
	name = "desert_3",
	match = {
		temperature = 90,
		humidity = 20
	},

	flat = MP .. "/schematics/base/grass_flat",

	slope_upper = MP .. "/schematics/base/grass_slope_upper",
	slope_lower = MP .. "/schematics/base/grass_slope_lower",

	slope_inner_upper = MP .."/schematics/base/grass_slope_inner_corner_upper",
	slope_inner_lower = MP .."/schematics/base/grass_slope_inner_corner_lower",

	slope_outer_upper = MP .."/schematics/base/grass_slope_outer_corner_upper",
	slope_outer_lower = MP .."/schematics/base/grass_slope_outer_corner_lower",

	replace = {
		["default:dirt_with_grass"] = "default:desert_sand",
		["eco_stairsplus:slope_dirt_with_grass"] = "eco_stairsplus:slope_desert_sand",
		["eco_stairsplus:slope_dirt_with_grass_inner_cut"] = "eco_stairsplus:slope_desert_sand_inner_cut",
		["eco_stairsplus:slope_dirt_with_grass_outer_cut"] = "eco_stairsplus:slope_desert_sand_outer_cut"
	}
})
