local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:street", {
	placement = "connected",
	groups = {
		street = true
	},
	ground_conditions = {
		{ near_support = true },
		{ on_solid_underground = true }
	},
	tiles = {
		["1,0,0"] = {
			default = true,
			connections = {
				["1,0,0"] = { groups = {"street"} },
				["-1,0,0"] = { groups = {"street"} },
				["0,0,1"] = { groups = {"street"} },
				["0,0,-1"] = { groups = {"street"} }
			},
			rotations = {0}
		},
		["2,0,0"] = {
			connections = {
				["1,0,0"] = { groups = {"street"} },
				["-1,0,0"] = { groups = {"street"} }
			},
			rotations = {0,90}
		},
		["3,0,0"] = {
			connections = {
				["1,0,0"] = { groups = {"street"} },
				["-1,0,0"] = { groups = {"street"} },
				["0,0,1"] = { groups = {"street"} }
			},
			rotations = {0,90,180,270}
		},
		["4,0,0"] = {
			connections = {
				["-1,0,0"] = { groups = {"street"} },
				["0,0,1"] = { groups = {"street"} }
			},
			rotations = {0,90,180,270}
		},
		["5,0,0"] = {
			connections = {
				["-1,0,0"] = { groups = {"street"} }
			},
			rotations = {0,90,180,270}
		}
	},
	catalog = MP .. "/schematics/street.zip"
})
