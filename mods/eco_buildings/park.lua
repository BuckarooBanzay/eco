local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:park", {
	description = "Park",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_building = "eco_buildings:park"
	}
})

building_lib.register({
	name = "eco_buildings:park",
	placement = "multi",
	conditions = {
		{ on_flat_surface = true, not_on_biome = "water" }
	},
	schematic = MP .. "/schematics/park/park"
})
