local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:stone_block", {
	description = "Stone block",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_building = "eco_buildings:stone_block",
		place_on = {
			mapgen_type = {"slope_lower"}
		}
	}
})

building_lib.register({
	name = "eco_buildings:stone_block",
	placement = "simple",
	groups = {
		support = true
	},
	schematic = MP .. "/schematics/stone_full"
})
