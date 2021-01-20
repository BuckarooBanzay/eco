local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome("snow", {
	match = function(mapblock_pos, info)
		return mapblock_pos.y >= 4 and info.type ~= "none" and info.type ~= "underground"
	end,

	flat = MP .. "/schematics/base/grass_flat",

	slope_upper = MP .. "/schematics/base/grass_slope_upper",
	slope_lower = MP .. "/schematics/base/grass_slope_lower",

	slope_inner_upper = MP .."/schematics/base/grass_slope_inner_corner_upper",
	slope_inner_lower = MP .."/schematics/base/grass_slope_inner_corner_lower",

	slope_outer_upper = MP .."/schematics/base/grass_slope_outer_corner_upper",
	slope_outer_lower = MP .."/schematics/base/grass_slope_outer_corner_lower",

	replace = {
		["default:dirt_with_grass"] = "default:dirt_with_snow",
		["eco_stairsplus:slope_dirt_with_grass"] = "eco_stairsplus:slope_dirt_with_snow",
		["eco_stairsplus:slope_dirt_with_grass_inner_cut"] = "eco_stairsplus:slope_dirt_with_snow_inner_cut",
		["eco_stairsplus:slope_dirt_with_grass_outer_cut"] = "eco_stairsplus:slope_dirt_with_snow_outer_cut"
	}
})
