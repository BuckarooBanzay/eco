local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:park", {
	catalog = MP .. "/schematics/park.zip",
	conditions = {
		{
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		}
	},
	groups = {
		park = true
	},
	stats = {
		noise = -0.5
	},
	overview = "eco:slab_grass_quarter"
})