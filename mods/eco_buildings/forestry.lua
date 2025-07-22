local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:forestry", {
	catalog = MP .. "/schematics/forestry.zip",
	conditions = {
		{
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		}
	},
	groups = {
		forest = true
	},
	stats = {
		noise = 1,
		industry = 1
	},
	overview = "eco:pine_wood"
})