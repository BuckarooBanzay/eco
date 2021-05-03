local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:street_slope", {
	description = "Simple sloped street",
	inventory_image = "eco_buildings_inv_street.png",
	eco = {
		place_building = "eco_buildings:street_slope"
	}
})

building_lib.register({
	name = "eco_buildings:street_slope",
	placement = "slope",
	groups = {
		--TODO: deprecate
		street = true
	},
	connections = {
		street = {"x+"}
	},
	conditions = {
		{ not_on_biome = "water", on_slope_lower = true }
	},
	schematics = {
		slope_lower = MP .. "/schematics/street/street_slope_lower",
		slope_upper = MP .. "/schematics/street/street_slope_upper"
	},
	deserialize_options = {
		transform = {
			rotate = {
				disable_orientation = {
					["default:stonebrick"] = true
				}
			},
			replace = {
				["eco_blocks:replacement_slope_1"] = "moreblocks:slope_stonebrick",
				["eco_blocks:replacement_2"] = "default:stonebrick",
				["eco_blocks:replacement_slope_3"] = "eco_stairsplus:slope_gravel"
			}
		}
	}
})
