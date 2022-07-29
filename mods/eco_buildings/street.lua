local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building({
	name = "eco_buildings:street",
	placement = "connected",
	groups = {
		street = true
	},
	connects_to_groups = {
		street = true
	},
	ground_conditions = {
		{ on_slope = true },
		{ near_support = true },
		{ on_solid_underground = true }
	},
	catalog = MP .. "/schematics/street.zip"
})
