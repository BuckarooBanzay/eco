local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:pylon", {
	description = "Support pylon",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_building = "eco_buildings:pylon",
		place_on = {
			mapgen_type = {"flat"},
			biome = {"grass", "snow"}
		}
	}
})

building_lib.register({
	name = "eco_buildings:pylon",
	placement = "simple",
	schematic = MP .. "/schematics/pylon"
})
