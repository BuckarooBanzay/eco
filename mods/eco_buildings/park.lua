local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:park", {
	catalog = MP .. "/schematics/park.zip",
	conditions = {
		{
			-- flat surface
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		},{
			-- on existing plot
			["base"] = { group = "plot_2x2" }
		}
	},
	groups = {
		park = true
	},
	overview = "eco:slab_grass_quarter"
})