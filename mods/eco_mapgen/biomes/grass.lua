local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome({
	name = "grass",
	match = {
		temperature = 50,
		humidity = 50
	},
	catalog = MP .."/schematics/terrain.zip"
})
