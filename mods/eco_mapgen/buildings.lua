local MP = minetest.get_modpath("eco_mapgen")

building_lib.register_building("eco_mapgen:terrain_surface", {
	category = "terrain",
	catalog = {
		filename = MP .. "/schematics/terrain.zip",
		offset = {x=0, y=0, z=0},
		size = {x=1, y=1, z=1},
        cache = true
	},
	replace = {
		["eco:cobble"] = "eco:grass"
	},
	groups = {
		flat_surface = true,
		support = true
	},
	overview = "eco:grass"
})

building_lib.register_building("eco_mapgen:terrain_underground", {
	category = "terrain",
	catalog = {
		filename = MP .. "/schematics/terrain.zip",
		offset = {x=0, y=0, z=0},
		size = {x=1, y=1, z=1},
        cache = true
	},
	replace = {
		["eco:cobble"] = "eco:stone"
	},
	groups = {
		flat_surface = true,
		support = true
	},
	overview = "eco:stone"
})

building_lib.register_building("eco_mapgen:terrain_slope_inner", {
	category = "terrain",
	catalog = {
		filename = MP .. "/schematics/terrain.zip",
		offset = {x=1, y=0, z=0},
		size = {x=1, y=1, z=1},
        cache = true
	},
	replace = {
		["eco:slope_stone_inner"] = "eco:slope_grass_inner",
		["eco:slope_stone"] = "eco:slope_grass"
	},
	groups = {
		terrain_slope_inner = true
	},
	overview = "eco:slope_grass_inner"
})

building_lib.register_building("eco_mapgen:terrain_slope", {
	category = "terrain",
	catalog = {
		filename = MP .. "/schematics/terrain.zip",
		offset = {x=2, y=0, z=0},
		size = {x=1, y=1, z=1},
        cache = true
	},
	replace = {
		["eco:slope_stone"] = "eco:slope_grass"
	},
	rotation_offset = 90,
	groups = {
		terrain_slope = true
	},
	overview = "eco:slope_grass"
})

building_lib.register_building("eco_mapgen:terrain_slope_outer", {
	category = "terrain",
	catalog = {
		filename = MP .. "/schematics/terrain.zip",
		offset = {x=3, y=0, z=0},
		size = {x=1, y=1, z=1},
        cache = true
	},
	replace = {
		["eco:slope_stone_outer"] = "eco:slope_grass_outer",
		["eco:slope_stone"] = "eco:slope_grass"
	},
	groups = {
		terrain_slope_outer = true
	},
	overview = "eco:slope_grass_outer"
})

building_lib.register_building("eco_mapgen:water", {
	category = "terrain",
	catalog = {
		filename = MP .. "/schematics/full.zip",
        cache = true
	},
	replace = {
		["full_block"] = "eco:water_source"
	},
	groups = {
		water = true
	},
	overview = "eco:water_static"
})
