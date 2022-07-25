eco_mapgen.register_biome({
	name = "ice",
	match = {
		temperature = 0,
		humidity = 20
	},
	replace = {
		["eco:cobble"] = "eco:ice",
		["eco:slope_stone"] = "eco:slope_ice",
		["eco:slope_stone_inner"] = "eco:slope_ice_inner",
		["eco:slope_stone_outer"] = "eco:slope_ice_outer"
	}
})
