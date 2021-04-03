local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:house", {
	description = "Simple house",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_building = "eco_buildings:house",
		place_checks = {
			eco_checks.mapgen_type("flat"),
			eco_checks.some(
				eco_checks.biome("grass"),
				eco_checks.biome("snow")
			)
		},
		place_on = {
			-- DEPRECATED
			mapgen_type = {"flat"},
			biome = {"grass", "snow"}
		}
	}
})

building_lib.register({
	name = "eco_buildings:house",
	placement = "simple",
	schematic = MP .. "/schematics/house"
})
