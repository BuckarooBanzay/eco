local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:pylon", {
	description = "Support pylon",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_on = { "flat" },
		mode = "simple",
		schematic = MP .. "/schematics/pylon",
		is_support = true
	}
})
