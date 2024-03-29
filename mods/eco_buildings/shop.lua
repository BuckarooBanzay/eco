local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:shop_1", {
	catalog = MP .. "/schematics/shop_1.zip",
	conditions = {
		{
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		}
	},
	markers = {
		{
			texture = "building_lib_arrow.png",
			position = {x=1, y=0.2, z=2.5},
			rotation = {x=math.pi/2, y=0, z=math.pi},
			size = {x=10, y=10}
		}
	},
	replace = eco_buildings.replacement_randomizer({
		base_color = {
			["eco:stair_baked_clay_white"] = {
				"eco:stair_baked_clay_white",
				"eco:stair_baked_clay_blue",
				"eco:stair_baked_clay_green",
				"eco:stair_baked_clay_red"
			},
			["eco:stair_baked_clay_white_inner"] = {
				"eco:stair_baked_clay_white_inner",
				"eco:stair_baked_clay_blue_inner",
				"eco:stair_baked_clay_green_inner",
				"eco:stair_baked_clay_red_inner"
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
