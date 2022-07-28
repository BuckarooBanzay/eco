local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building({
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
		{ on_solid_underground = true },
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
