local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:timber_plantation", {
	description = "Timber plantation",
	inventory_image = "default_wood.png",
	eco = {
		place_building = "eco_buildings:timber_plantation"
	}
})

building_lib.register({
	name = "eco_buildings:timber_plantation",
	placement = "simple",
	schematic = MP .. "/schematics/timber_plantation",
	conditions = {
		{ not_in_water = true, on_flat_surface = true }
	}
})
