local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:park", {
	catalog = MP .. "/schematics/park.zip",
	conditions = {
		{
			["*"] = { empty_or_group = "plot_2x2" },
			["base"] = { group = "plot_2x2" },
			["underground"] = { group = "flat_surface"}
		}
	},
	groups = {
		park = true
	},
	overview = "eco:slab_grass_quarter"
})