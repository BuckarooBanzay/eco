local MP = minetest.get_modpath("eco_buildings")

local has_street_signs = minetest.get_modpath("street_signs")

local disable_orientation = {
	["eco:stone_bricks"] = true,
	["eco:silver_sandstone_brick"] = true,
	["street_signs:sign_basic"] = true
}

-- no-op per default
local function on_streetsign_metadata() end

if has_street_signs then
	-- add streetsign metadata callback
	local content_street_sign = minetest.get_content_id("street_signs:sign_basic")

	on_streetsign_metadata = function(pos, content_id, meta)
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
end

building_lib.register_building("eco_buildings:street_slope", {
	category = "street",
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
	category = "street",
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
		street_gravel = true,
		street_tunnel = true
	},
	overview = "eco:slab_gravel_2"
})

local street_tile_conditions = {
	{
		["*"] = { empty = true },
		["underground"] = { group = "flat_surface" }
	},{
		["*"] = { empty = true, support_below = true }
	},{
		["*"] = { group = "street_gravel"}
	}
}

building_lib.register_building("eco_buildings:street_straight", {
	category = "street",
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
		street_gravel = true,
		street_connecting = true
	},
	overview = "eco:slab_gravel_2"
})

building_lib.register_building("eco_buildings:street_all_sides", {
	category = "street",
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
		street_gravel = true,
		street_connecting = true
	},
	conditions = street_tile_conditions,
	overview = "eco:slab_gravel_2"
})

building_lib.register_building("eco_buildings:street_t", {
	category = "street",
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
		street_gravel = true,
		street_connecting = true
	},
	conditions = street_tile_conditions,
	overview = "eco:slab_gravel_2"
})

building_lib.register_building("eco_buildings:street_corner", {
	category = "street",
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
		street_gravel = true,
		street_connecting = true
	},
	conditions = street_tile_conditions,
	overview = "eco:slab_gravel_2"
})

building_lib.register_autoplacer("street", {
	propagate = { group = "street_gravel" },
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