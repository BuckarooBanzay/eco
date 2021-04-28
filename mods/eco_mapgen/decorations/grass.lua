local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_decoration({
	match = {
		biome = "grass",
		mapgen_type = "flat",
		min_height = 2,
		chance = 4
	},
	schematics = {
		MP .. "/schematics/decorations/grass_with_tree_1",
		MP .. "/schematics/decorations/grass_with_tree_2",
		MP .. "/schematics/decorations/grass_with_tree_3",
		MP .. "/schematics/decorations/grass_with_tree_4"
	}
})

eco_mapgen.register_decoration({
	match = {
		biome = "snow",
		mapgen_type = "flat",
		chance = 10
	},
	schematics = {
		MP .. "/schematics/decorations/grass_with_pinetree_1",
		MP .. "/schematics/decorations/grass_with_pinetree_2",
		MP .. "/schematics/decorations/grass_with_pinetree_3",
		MP .. "/schematics/decorations/grass_with_pinetree_4"
	}
})
