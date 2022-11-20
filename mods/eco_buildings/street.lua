local MP = minetest.get_modpath("eco_buildings")

local disable_orientation = {
	["eco:stone_bricks"] = true,
	["eco:grey_bricks"] = true,
	["street_signs:signs_basic"] = true
}

local content_street_sign = minetest.get_content_id("street_signs:sign_basic")

local function on_streetsign_metadata(pos, content_id, meta)
	if content_id == content_street_sign then
		-- write street name
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
		local z_streetname = eco_buildings.get_street_name(mapblock_pos.x * 3)
		local x_streetname = eco_buildings.get_street_name((mapblock_pos.z * 3) + 2048)
		local txt = z_streetname .. "\n" .. x_streetname
		meta:set_string("infotext", txt)
		meta:set_string("text", txt)
	end
end

building_lib.register_building("eco_buildings:street_slope", {
	catalog = {
		filename = MP .. "/schematics/street.zip",
		offset = {x=0, y=0, z=0},
		size = {x=1, y=2, z=1}
	},
	rotation_offset = 180,
	disable_orientation = disable_orientation,
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
			return { name="eco:slope_gravel", param2 = 3 }
		end
	end
})

building_lib.register_building("eco_buildings:street_tunnel", {
	catalog = {
		filename = MP .. "/schematics/street.zip",
		offset = {x=2, y=0, z=2},
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
	disable_orientation = disable_orientation,
	conditions = {
		{
			["*"] = { group = "support" }
		}
	},
	groups = {
		street = true,
		street_connecting = true,
		street_tunnel = true
	},
	overview = "eco:slab_gravel_2"
})

local street_tile_conditions = {
	{
		["*"] = { empty = true },
		["underground"] = { group = "flat_surface" }
	},{
		["*"] = { empty = true, near_support = true }
	},{
		["*"] = { group = "street_flat"}
	}
}

building_lib.register_building("eco_buildings:street_straight", {
	catalog = {
		filename = MP .. "/schematics/street.zip",
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
	disable_orientation = disable_orientation,
	conditions = street_tile_conditions,
	groups = {
		street = true,
		street_flat = true,
		street_connecting = true
	},
	overview = "eco:slab_gravel_2"
})

building_lib.register_building("eco_buildings:street_all_sides", {
	catalog = {
		filename = MP .. "/schematics/street.zip",
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
	on_metadata = on_streetsign_metadata,
	disable_orientation = disable_orientation,
	groups = {
		street = true,
		street_flat = true,
		street_connecting = true
	},
	conditions = street_tile_conditions,
	overview = "eco:slab_gravel_2"
})

building_lib.register_building("eco_buildings:street_t", {
	catalog = {
		filename = MP .. "/schematics/street.zip",
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
	on_metadata = on_streetsign_metadata,
	disable_orientation = disable_orientation,
	groups = {
		street = true,
		street_flat = true,
		street_connecting = true
	},
	conditions = street_tile_conditions,
	overview = "eco:slab_gravel_2"
})

building_lib.register_building("eco_buildings:street_corner", {
	catalog = {
		filename = MP .. "/schematics/street.zip",
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
	on_metadata = on_streetsign_metadata,
	disable_orientation = disable_orientation,
	groups = {
		street = true,
		street_flat = true,
		street_connecting = true
	},
	conditions = street_tile_conditions,
	overview = "eco:slab_gravel_2"
})

building_lib.register_autoplacer("street", {
	propagate = { group = "street_flat" },
	buildings = {
		{
			name = "eco_buildings:street_all_sides",
			rotations = {0},
			fallback = true,
			conditions = {
				["(0,0,1)"] = { group = "street" },
				["(0,0,-1)"] = { group = "street" },
				["(1,0,0)"] = { group = "street" },
				["(-1,0,0)"] = { group = "street" }
			}
		},{
			name = "eco_buildings:street_t",
			rotations = {0, 90, 180, 270},
			conditions = {
				["(1,0,0)"] = { group = "street" },
				["(-1,0,0)"] = { group = "street" },
				["(0,0,1)"] = { group = "street" }
			}
		},{
			name = "eco_buildings:street_corner",
			rotations = {0, 90, 180, 270},
			conditions = {
				["(0,0,1)"] = { group = "street" },
				["(-1,0,0)"] = { group = "street" }
			}
		},{
			name = "eco_buildings:street_straight",
			rotations = {0, 90},
			conditions = {
				["(1,0,0)"] = { group = "street" },
				["(-1,0,0)"] = { group = "street" }
			}
		},{
			name = "eco_buildings:street_tunnel",
			rotations = {0, 90, 180, 270},
			conditions = {
				["(1,0,0)"] = { group = "street" },
				["(0,0,0)"] = { group = "support"}
			}
		},{
			name = "eco_buildings:street_slope",
			rotations = {0, 90, 180, 270},
			conditions = {
				["(-1,0,0)"] = { group = "street" },
				["(1,1,0)"] = { group = "street" }
			}
		}
	}
})