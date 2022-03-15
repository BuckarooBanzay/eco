local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:pylon", {
	description = "Support pylon",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_building = "eco_buildings:pylon"
	}
})

building_lib.register({
	name = "eco_buildings:pylon",
	placement = "simple",
	schematic = MP .. "/schematics/pylon",
	conditions = {
		{ not_on_biome = "water", on_group = "support" },
		{ not_on_biome = "water", on_flat_surface = true }
	},
	groups = {
		support = true
	}
})
