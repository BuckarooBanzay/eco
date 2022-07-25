eco_mapgen.register_biome({
	name = "grass",
	match = {
		temperature = 50,
		humidity = 50
	},
	replace = {
		["eco:cobble"] = "eco:grass",
		["eco:slope_stone"] = "eco:slope_grass",
		["eco:slope_stone_inner"] = "eco:slope_grass_inner",
		["eco:slope_stone_outer"] = "eco:slope_grass_outer"
	}
})
