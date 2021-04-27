local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:street", {
	description = "Simple street",
	inventory_image = "eco_buildings_inv_street.png",
	eco = {
		place_building = "eco_buildings:street"
	}
})

building_lib.register({
	name = "eco_buildings:street",
	placement = "connected",
	connects_to = {
		street = true
	},
	groups = {
		street = true
	},
	conditions = {
		{ not_on_biome = "water", on_flat_surface = true },
		{ near_support = true }
	},
	schematics = {
		straight = MP .. "/schematics/street/street_straight",
		all_sides = MP .. "/schematics/street/street_all_sides",
		corner = MP .. "/schematics/street/street_corner",
		three_sides = MP .. "/schematics/street/street_three_sides"
	},
	deserialize_options = {
		transform = {
			rotate = {
				disable_orientation = {
					["default:stonebrick"] = true
				}
			}
		}
	}
})
