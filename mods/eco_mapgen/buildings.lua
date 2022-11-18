local MP = minetest.get_modpath("eco_mapgen")

building_lib.register_building("eco_mapgen:terrain_surface", {
	catalog = {
		filename = MP .. "/schematics/terrain.zip",
		offset = {x=0, y=0, z=0},
		size = {x=1, y=1, z=1},
        cache = true
	},
	replace = {
		["default:cobble"] = "default:dirt_with_grass"
	},
	groups = {
		flat_surface = true,
		support = true
	},
	overview = "default:dirt_with_grass"
})

building_lib.register_building("eco_mapgen:terrain_surface_dry", {
	catalog = {
		filename = MP .. "/schematics/terrain.zip",
		offset = {x=0, y=0, z=0},
		size = {x=1, y=1, z=1},
        cache = true
	},
	replace = {
		["default:cobble"] = "default:dirt_with_dry_grass"
	},
	groups = {
		flat_surface = true,
		support = true
	},
	overview = "default:dirt_with_dry_grass"
})

building_lib.register_building("eco_mapgen:terrain_underground", {
	catalog = {
		filename = MP .. "/schematics/terrain.zip",
		offset = {x=0, y=0, z=0},
		size = {x=1, y=1, z=1},
        cache = true
	},
	replace = {
		["default:cobble"] = "default:stone"
	},
	groups = {
		flat_surface = true,
		support = true
	},
	overview = "default:stone"
})

building_lib.register_building("eco_mapgen:terrain_slope_inner", {
	catalog = {
		filename = MP .. "/schematics/terrain.zip",
		offset = {x=1, y=0, z=0},
		size = {x=1, y=1, z=1},
        cache = true
	},
	overview = "moreblocks:slope_stone_inner"
})

building_lib.register_building("eco_mapgen:terrain_slope", {
	catalog = {
		filename = MP .. "/schematics/terrain.zip",
		offset = {x=2, y=0, z=0},
		size = {x=1, y=1, z=1},
        cache = true
	},
	rotation_offset = 90,
	groups = {
		terrain_slope = true
	},
	overview = "moreblocks:slope_stone"
})

building_lib.register_building("eco_mapgen:terrain_slope_outer", {
	catalog = {
		filename = MP .. "/schematics/terrain.zip",
		offset = {x=3, y=0, z=0},
		size = {x=1, y=1, z=1},
        cache = true
	},
	overview = "moreblocks:slope_stone_outer"
})

building_lib.register_building("eco_mapgen:water", {
	catalog = {
		filename = MP .. "/schematics/full.zip",
        cache = true
	},
	replace = {
		["full_block"] = "default:water_source"
	},
	groups = {
		water = true
	},
	overview = "wool:blue"
})
