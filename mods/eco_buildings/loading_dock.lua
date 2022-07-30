local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:loading_dock", {
	placement = "connected",
	groups = {
		loading_dock = true,
		street = true
	},
	tiles = {
		["0,0,0"] = {
			ground_conditions = {
				{ on_group = "support" },
				{ on_solid_underground = true }
			},
			connections = {
				["1,0,0"] = { groups = {"street"} }
			}
		}
	},
	catalog = MP .. "/schematics/loading_dock.zip"
})
