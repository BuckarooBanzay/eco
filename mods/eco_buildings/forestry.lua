local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:forestry", {
	catalog = MP .. "/schematics/forestry.zip",
	conditions = {
		{
			-- flat surface
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		}
	},
	groups = {
		forest = true
	},
	overview = "eco:pine_wood"
})