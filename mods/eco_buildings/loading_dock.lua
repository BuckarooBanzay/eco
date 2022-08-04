local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:loading_dock", {
	placement = "simple",
	groups = {
		loading_dock = true
	},
	ground_conditions = {
		{ on_group = "support" },
		{ on_solid_underground = true }
	},
	connections = {
		["0,0,1"] = "street"
	},
	catalog = MP .. "/schematics/loading_dock.zip"
})
