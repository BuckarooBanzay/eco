local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:strut", {
	catalog = MP .. "/schematics/strut.zip",
	conditions = {
        {
			-- flat surface
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		},{
			-- stacked
			["*"] = { empty = true },
			["underground"] = { group = "support"}
		}
	},
	groups = {
		strut = true,
        support = true
	},
	overview = "eco:grey_bricks"
})