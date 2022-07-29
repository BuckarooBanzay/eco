local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building({
	name = "eco_buildings:park",
	placement = "simple",
	groups = {
		park = true
	},
	catalog = MP .. "/schematics/park.zip"
})
