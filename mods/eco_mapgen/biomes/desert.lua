local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome({
	name = "desert_1",
	match = {
		temperature = 80,
		humidity = 20
	},
	catalog = MP .."/schematics/mapgen_grass.zip",

	replace = {
		["eco:grass"] = "eco:silver_sand",
		["eco:slope_grass"] = "eco:slope_silver_sand",
		["eco:slope_grass_inner_cut"] = "eco:slope_silver_sand_inner_cut",
		["eco:slope_grass_outer_cut"] = "eco:slope_silver_sand_outer_cut"
	}
})

eco_mapgen.register_biome({
	name = "desert_2",
	match = {
		temperature = 85,
		humidity = 20
	},
	catalog = MP .."/schematics/mapgen_grass.zip",

	replace = {
		["eco:grass"] = "eco:sand",
		["eco:slope_grass"] = "eco:slope_sand",
		["eco:slope_grass_inner_cut"] = "eco:slope_sand_inner_cut",
		["eco:slope_grass_outer_cut"] = "eco:slope_sand_outer_cut"
	}
})

eco_mapgen.register_biome({
	name = "desert_3",
	match = {
		temperature = 90,
		humidity = 20
	},
	catalog = MP .."/schematics/mapgen_grass.zip",

	replace = {
		["eco:grass"] = "eco:desert_sand",
		["eco:slope_grass"] = "eco:slope_desert_sand",
		["eco:slope_grass_inner_cut"] = "eco:slope_desert_sand_inner_cut",
		["eco:slope_grass_outer_cut"] = "eco:slope_desert_sand_outer_cut"
	}
})
