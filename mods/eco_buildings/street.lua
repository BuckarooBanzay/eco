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
	connections = {
		street = {
			{x=1,y=0,z=0},
			{x=-1,y=0,z=0},
			{x=0,y=0,z=1},
			{x=0,y=0,z=-1}
		}
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
			},
			replace = {
				["eco_blocks:replacement_1"] = "default:stonebrick",
				["eco_blocks:replacement_2"] = "default:stonebrick",
				["eco_blocks:replacement_3"] = "default:gravel"
			}
		}
	}
})
