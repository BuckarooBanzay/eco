local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:house_1", {
	catalog = MP .. "/schematics/house_1.zip",
	conditions = {
		{
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		}
	},
	markers = {
		{
			type = "arrow",
			pos = { x=0.5, z=2 },
			rotation = "z+"
		}
	},
	replace = eco_buildings.replacement_randomizer({
		base_color = {
			["eco:slope_baked_clay_white_half_raised"] = {
				"eco:slope_baked_clay_white_half_raised",
				"eco:slope_baked_clay_blue_half_raised",
				"eco:slope_baked_clay_green_half_raised",
				"eco:slope_baked_clay_red_half_raised"
			},
			["eco:slope_baked_clay_white_half"] = {
				"eco:slope_baked_clay_white_half",
				"eco:slope_baked_clay_blue_half",
				"eco:slope_baked_clay_green_half",
				"eco:slope_baked_clay_red_half"
			},
			["eco:baked_clay_white"] = {
				"eco:baked_clay_white",
				"eco:baked_clay_blue",
				"eco:baked_clay_green",
				"eco:baked_clay_red"
			},
			-- overview node
			["eco:slab_baked_clay_white"] = {
				"eco:slab_baked_clay_white",
				"eco:slab_baked_clay_blue",
				"eco:slab_baked_clay_green",
				"eco:slab_baked_clay_red"
			}
		},
		floor = {
			["eco:jungle_wood"] = {
				"eco:jungle_wood",
				"eco:oak_wood"
			}
		},
		tree = {
			["eco:oak_tree"] = {
				"eco:oak_tree",
				"eco:pine_tree",
				"eco:acacia_tree",
				"air"
			},
			["eco:oak_leaves"] = {
				"eco:oak_leaves",
				"eco:pine_leaves",
				"eco:acacia_leaves",
				"air"
			}
		},
		outdoor = {
			["eco:grass_1"] = {
				"eco:grass_1",
				"eco:dry_grass_1"
			},
			["eco:grass_2"] = {
				"eco:grass_2",
				"eco:dry_grass_2"
			},
			["eco:grass_3"] = {
				"eco:grass_3",
				"eco:dry_grass_3"
			},
			["eco:grass_4"] = {
				"eco:grass_4",
				"eco:dry_grass_4"
			},
			["eco:grass_5"] = {
				"eco:grass_5",
				"eco:dry_grass_5"
			},
			["eco:grass"] = {
				"eco:grass",
				"eco:dry_grass"
			}
		}
	}),
	groups = {
		house = true
	},
	overview = function(_, event)
		local nodename = event.replacements["eco:slab_baked_clay_white"] or "eco:slab_baked_clay_white"
		return { name = nodename }
	end
})
