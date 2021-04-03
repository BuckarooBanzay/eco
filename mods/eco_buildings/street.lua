local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:street", {
	description = "Simple street",
	inventory_image = "eco_buildings_inv_street.png",
	eco = {
		place_building = "eco_buildings:street",
		place_on = {
			mapgen_type = {"flat", "slope_lower"},
			biome = {"grass", "snow"}
		}
	}
})

building_lib.register({
	name = "eco_buildings:street",
	placement = "connected",
	schematics = {
		straight = MP .. "/schematics/street/street_straight",
		all_sides = MP .. "/schematics/street/street_all_sides",
		corner = MP .. "/schematics/street/street_corner",
		three_sides = MP .. "/schematics/street/street_three_sides",
		slope_lower = MP .. "/schematics/street/street_slope_lower",
		slope_upper = MP .. "/schematics/street/street_slope_upper",
	}
})
