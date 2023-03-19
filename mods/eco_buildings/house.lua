local MP = minetest.get_modpath("eco_buildings")

-- eco:silver_sandstone_brick_colorable
-- eco:slope_baked_clay_white_half_raised
-- eco:slope_baked_clay_white_half
-- eco:jungle_wood

local function replacement_randomizer(replacement_map)
	return function()
		local replacements = {}
		for _, group in pairs(replacement_map) do
			local sync_i
			for src, choices in pairs(group) do
				if not sync_i then
					sync_i = math.random(#choices)
				end

				local new_nodename = choices[sync_i]
				if src ~= new_nodename then
					replacements[src] = new_nodename
				end
			end
		end
		return replacements
	end
end

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
			texture = "building_lib_arrow.png",
			position = {x=1, y=0.2, z=2.5},
			rotation = {x=math.pi/2, y=0, z=math.pi},
			size = {x=10, y=10}
		}
	},
	replace = replacement_randomizer({
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
		},
		floor = {
			["eco:jungle_wood"] = {
				"eco:jungle_wood",
				"eco:oak_wood"
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
	overview = "eco:slab_baked_clay_white"
})
