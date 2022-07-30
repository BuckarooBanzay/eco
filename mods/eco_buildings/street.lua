local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:street", {
	placement = "connected",
	groups = {
		street = true
	},
	tiles = {
		["0,0,0"] = {
			size = { x=1, y=2, z=1 },
			ground_conditions = {
				{ on_slope = true }
			},
			connections = {
				["1,1,0"] = { groups = {"street"} },
				["-1,0,0"] = { groups = {"street"} }
			}
		},
		["1,0,0"] = {
			default = true,
			ground_conditions = {
				{ near_support = true },
				{ on_solid_underground = true }
			},
			connections = {
				["1,0,0"] = { groups = {"street"} },
				["-1,0,0"] = { groups = {"street"} },
				["0,0,1"] = { groups = {"street"} },
				["0,0,-1"] = { groups = {"street"} }
			}
		},
		["2,0,0"] = {
			ground_conditions = {
				{ near_support = true },
				{ on_solid_underground = true }
			},
			connections = {
				["1,0,0"] = { groups = {"street"} },
				["-1,0,0"] = { groups = {"street"} }
			}
		},
		["3,0,0"] = {
			ground_conditions = {
				{ near_support = true },
				{ on_solid_underground = true }
			},
			connections = {
				["1,0,0"] = { groups = {"street"} },
				["-1,0,0"] = { groups = {"street"} },
				["0,0,1"] = { groups = {"street"} }
			}
		},
		["4,0,0"] = {
			ground_conditions = {
				{ near_support = true },
				{ on_solid_underground = true }
			},
			connections = {
				["-1,0,0"] = { groups = {"street"} },
				["0,0,1"] = { groups = {"street"} }
			}
		},
		["5,0,0"] = {
			ground_conditions = {
				{ near_support = true },
				{ on_solid_underground = true }
			},
			connections = {
				["-1,0,0"] = { groups = {"street"} }
			}
		}
	},
	catalog = MP .. "/schematics/street.zip"
})
