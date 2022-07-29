local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:foundation", {
	placement = "simple",
	groups = {
		strut = true,
		support = true,
		foundation = true
	},
	ground_conditions = {
		{ on_slope = true },
		{ on_group = "foundation" },
		{ on_solid_underground = true }
	},
	catalog = MP .. "/schematics/foundation.zip"
})
