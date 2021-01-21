local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:street", {
	description = "Simple street",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_on = { "flat", "slope" },
		mode = "connected_rotate",
		schematics = {
			straight = MP .. "/schematics/street_straight",
			all_sides = MP .. "/schematics/street_all_sides",
			corner = MP .. "/schematics/street_corner",
			three_sides = MP .. "/schematics/street_three_sides",
			slope_lower = MP .. "/schematics/street_slope_lower",
			slope_upper = MP .. "/schematics/street_slope_upper",
		}
	}
})
