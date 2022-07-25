eco_mapgen.register_biome({
	name = "desert_1",
	match = {
		temperature = 80,
		humidity = 20
	},
	replace = {
		["eco:cobble"] = "eco:silver_sand",
		["eco:slope_stone"] = "eco:slope_silver_sand",
		["eco:slope_stone_inner"] = "eco:slope_silver_sand_inner",
		["eco:slope_stone_outer"] = "eco:slope_silver_sand_outer"
	}
})

eco_mapgen.register_biome({
	name = "desert_2",
	match = {
		temperature = 85,
		humidity = 20
	},
	replace = {
		["eco:cobble"] = "eco:sand",
		["eco:slope_stone"] = "eco:slope_sand",
		["eco:slope_stone_inner"] = "eco:slope_sand_inner",
		["eco:slope_stone_outer"] = "eco:slope_sand_outer"
	}
})

eco_mapgen.register_biome({
	name = "desert_3",
	match = {
		temperature = 90,
		humidity = 20
	},
	replace = {
		["eco:cobble"] = "eco:desert_sand",
		["eco:slope_stone"] = "eco:slope_desert_sand",
		["eco:slope_stone_inner"] = "eco:slope_desert_sand_inner",
		["eco:slope_stone_outer"] = "eco:slope_desert_sand_outer"
	}
})
