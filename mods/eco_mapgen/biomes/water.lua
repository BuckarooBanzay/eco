local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome({
	name = "water",
	match = function(mapblock_pos, info)
		return mapblock_pos.y < 0 and info.type ~= "underground"
	end,

	flat = MP .. "/schematics/base/water_flat",

	slope_upper = MP .. "/schematics/base/water_slope_upper",
	slope_lower = MP .. "/schematics/base/water_slope_lower",

	slope_inner_upper = MP .."/schematics/base/water_slope_inner_corner_upper",
	slope_inner_lower = MP .."/schematics/base/water_slope_inner_corner_lower",

	slope_outer_upper = MP .."/schematics/base/water_slope_outer_corner_upper",
	slope_outer_lower = MP .."/schematics/base/water_slope_outer_corner_lower",

	empty = MP .. "/schematics/base/water_full"
})
