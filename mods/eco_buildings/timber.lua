local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:timber_plantation", {
	description = "Timer plantation",
	inventory_image = "default_wood.png",
	eco = {
		place_on = { "flat" },
		mode = "simple",
		schematic = MP .. "/schematics/timber_plantation"
	}
})
