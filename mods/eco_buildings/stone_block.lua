local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:stone_block", {
    description = "Stone block",
    inventory_image = "default_mese_crystal.png",
    eco = {
		place_building = "eco_buildings:stone_block"
	}
})

building_lib.register({
    name = "eco_buildings:stone_block",
    placement = "simple",
    conditions = {
		on_slope_lower = true,
		on_flat_surface = true
	},
    groups = {
		support = true
	},
    schematic = MP .. "/schematics/stone_full"
})
