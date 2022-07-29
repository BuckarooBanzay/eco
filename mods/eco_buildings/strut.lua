local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building({
	name = "eco_buildings:strut",
	placement = "simple",
	groups = {
		strut = true,
		support = true
	},
	catalog = MP .. "/schematics/strut.zip"
})
