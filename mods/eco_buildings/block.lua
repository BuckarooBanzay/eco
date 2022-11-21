local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:block", {
	catalog = MP .. "/schematics/full.zip",
	conditions = {
        {
			-- flat surface
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		},{
			-- slope
			["*"] = { group = "terrain_slope" },
		},{
			-- slope inner
			["*"] = { group = "terrain_slope_inner" },
		},{
			-- slope outer
			["*"] = { group = "terrain_slope_outer" },
		},{
			-- on water
			["*"] = { group = "water" },
			["underground"] = { group = "flat_surface"}
		}
	},
	groups = {
        flat_surface = true
	},
    replace = {
		["full_block"] = "eco:stone"
	},
	overview = "eco:stone"
})