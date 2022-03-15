local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:stone_platform", {
	description = "Stone platform",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_building = "eco_buildings:stone_platform"
	}
})

building_lib.register({
	name = "eco_buildings:stone_platform",
	placement = "simple",
	conditions = {
		{ not_in_water = true, on_flat_surface = true }
	},
	schematic = MP .. "/schematics/stone_platform"
})
