local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:house", {
	description = "Simple house",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_building = "eco_buildings:house"
	}
})

building_lib.register({
	name = "eco_buildings:house",
	placement = "simple",
	conditions = {
		{ on_flat_surface = true, not_on_biome = "water" }
	},
	schematic = MP .. "/schematics/house"
})
