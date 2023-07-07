local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:dirt_street_slope", {
	category = "street",
	catalog = {
		filename = MP .. "/schematics/dirt_street.zip",
		offset = {x=0, y=0, z=0},
		size = {x=1, y=2, z=1}
	},
	rotation_offset = 180,
	conditions = {
		{
			-- existing slope
			["base"] = { group = "terrain_slope" }
		},{
			-- flat surface
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		},{
			-- support
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		}
	},
	groups = {
		street_slope = true,
		street = true
	},
	overview = function(rel_mapblock_pos)
		if vector.equals(rel_mapblock_pos, {x=0,y=0,z=0}) then
			-- only show lower slope part in overview
			return { name="eco:slope_dirt", param2 = 3 }
		end
	end
})

local street_tile_conditions = {
	{
		["*"] = { empty = true },
		["underground"] = { group = "flat_surface" }
	},{
		["*"] = { group = "street_flat"}
	}
}

building_lib.register_building("eco_buildings:dirt_street_straight", {
	category = "street",
	catalog = {
		filename = MP .. "/schematics/dirt_street.zip",
		offset = {x=2, y=0, z=0},
		size = {x=1, y=1, z=1}
	},
	markers = {
		{
			texture = "building_lib_arrow.png",
			position = {x=1.5, y=0.2, z=0.5},
			rotation = {x=math.pi/2, y=0, z=math.pi/2},
			size = {x=10, y=10}
		},{
			texture = "building_lib_arrow.png",
			position = {x=-0.5, y=0.2, z=0.5},
			rotation = {x=math.pi/2, y=0, z=-math.pi/2},
			size = {x=10, y=10}
		}
	},
	conditions = street_tile_conditions,
	groups = {
		street = true,
		street_flat = true,
		street_connecting = true
	},
	overview = "eco:slab_dirt_2"
})

building_lib.register_building("eco_buildings:dirt_street_all_sides", {
	category = "street",
	catalog = {
		filename = MP .. "/schematics/dirt_street.zip",
		offset = {x=1, y=0, z=0},
		size = {x=1, y=1, z=1}
	},
	markers = {
		{
			texture = "building_lib_arrow.png",
			position = {x=1.5, y=0.2, z=0.5},
			rotation = {x=math.pi/2, y=0, z=math.pi/2},
			size = {x=10, y=10}
		},{
			texture = "building_lib_arrow.png",
			position = {x=-0.5, y=0.2, z=0.5},
			rotation = {x=math.pi/2, y=0, z=-math.pi/2},
			size = {x=10, y=10}
		},{
			texture = "building_lib_arrow.png",
			position = {x=0.5, y=0.2, z=1.5},
			rotation = {x=math.pi/2, y=0, z=math.pi},
			size = {x=10, y=10}
		},{
			texture = "building_lib_arrow.png",
			position = {x=0.5, y=0.2, z=-0.5},
			rotation = {x=math.pi/2, y=0, z=0},
			size = {x=10, y=10}
		}
	},
	groups = {
		street = true,
		street_flat = true,
		street_connecting = true
	},
	conditions = street_tile_conditions,
	overview = "eco:slab_dirt_2"
})

building_lib.register_building("eco_buildings:dirt_street_t", {
	category = "street",
	catalog = {
		filename = MP .. "/schematics/dirt_street.zip",
		offset = {x=3, y=0, z=0},
		size = {x=1, y=1, z=1}
	},
	markers = {
		{
			texture = "building_lib_arrow.png",
			position = {x=1.5, y=0.2, z=0.5},
			rotation = {x=math.pi/2, y=0, z=math.pi/2},
			size = {x=10, y=10}
		},{
			texture = "building_lib_arrow.png",
			position = {x=-0.5, y=0.2, z=0.5},
			rotation = {x=math.pi/2, y=0, z=-math.pi/2},
			size = {x=10, y=10}
		},{
			texture = "building_lib_arrow.png",
			position = {x=0.5, y=0.2, z=1.5},
			rotation = {x=math.pi/2, y=0, z=math.pi},
			size = {x=10, y=10}
		}
	},
	groups = {
		street = true,
		street_flat = true,
		street_connecting = true
	},
	conditions = street_tile_conditions,
	overview = "eco:slab_dirt_2"
})

building_lib.register_building("eco_buildings:dirt_street_corner", {
	category = "street",
	catalog = {
		filename = MP .. "/schematics/dirt_street.zip",
		offset = {x=4, y=0, z=0},
		size = {x=1, y=1, z=1}
	},
	markers = {
		{
			texture = "building_lib_arrow.png",
			position = {x=-0.5, y=0.2, z=0.5},
			rotation = {x=math.pi/2, y=0, z=-math.pi/2},
			size = {x=10, y=10}
		},{
			texture = "building_lib_arrow.png",
			position = {x=0.5, y=0.2, z=1.5},
			rotation = {x=math.pi/2, y=0, z=math.pi},
			size = {x=10, y=10}
		}
	},
	groups = {
		street = true,
		street_flat = true,
		street_connecting = true
	},
	conditions = street_tile_conditions,
	overview = "eco:slab_dirt_2"
})

building_lib.register_autoplacer("dirt_street", {
	propagate = { group = "street_flat" },
	buildings = {
		{
			name = "eco_buildings:dirt_street_all_sides",
			rotations = {0},
			fallback = true,
			conditions = {
				["(0,0,1)"] = { group = "street" },
				["(0,0,-1)"] = { group = "street" },
				["(1,0,0)"] = { group = "street" },
				["(-1,0,0)"] = { group = "street" }
			}
		},{
			name = "eco_buildings:dirt_street_t",
			rotations = {0, 90, 180, 270},
			conditions = {
				["(1,0,0)"] = { group = "street" },
				["(-1,0,0)"] = { group = "street" },
				["(0,0,1)"] = { group = "street" }
			}
		},{
			name = "eco_buildings:dirt_street_corner",
			rotations = {0, 90, 180, 270},
			conditions = {
				["(0,0,1)"] = { group = "street" },
				["(-1,0,0)"] = { group = "street" }
			}
		},{
			name = "eco_buildings:dirt_street_straight",
			rotations = {0, 90},
			conditions = {
				["(1,0,0)"] = { group = "street" },
				["(-1,0,0)"] = { group = "street" }
			}
		},{
			name = "eco_buildings:dirt_street_slope",
			rotations = {0, 90, 180, 270},
			conditions = {
				["(-1,0,0)"] = { group = "street" },
				["(1,1,0)"] = { group = "street" }
			}
		}
	}
})