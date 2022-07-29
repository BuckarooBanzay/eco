local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building({
	name = "eco_buildings:park",
	placement = "simple",
	groups = {
		park = true
	},
	ground_conditions = {
		{ on_group = "support" },
		{ on_solid_underground = true }
	},
	catalog = MP .. "/schematics/park.zip"
})
