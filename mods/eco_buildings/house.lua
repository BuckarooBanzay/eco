local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:house_1", {
	catalog = MP .. "/schematics/house_1.zip",
	conditions = {
		{
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		}
	},
	groups = {
		house = true
	},
	overview = "eco:slab_baked_clay_white"
})