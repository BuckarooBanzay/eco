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
--		{ not_on_biome = "water", on_slope_lower = true },
		{ near_support = true }
	},
	catalog = MP .. "/schematics/street.zip",
	deserialize_options = {
		transform = {
			rotate = {
				disable_orientation = {
					["eco:stonebrick"] = true
				}
			}
		}
	}
})
