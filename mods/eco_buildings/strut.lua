local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:strut", {
	placement = "simple",
	groups = {
		strut = true,
		support = true
	},
	ground_conditions = {
		{ on_group = "support" },
		{ on_solid_underground = true }
	},
	catalog = MP .. "/schematics/strut.zip"
})
