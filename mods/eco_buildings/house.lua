local MP = minetest.get_modpath("eco_buildings")

-- eco:silver_sandstone_brick_colorable
-- eco:slope_baked_clay_white_half_raised
-- eco:slope_baked_clay_white_half
-- eco:jungle_wood

local function replacement_randomizer(replacement_map)
	return function()
		local replacements = {}

		local sync_i
		for src, choices in pairs(replacement_map.sync or {}) do
			if not sync_i then
				sync_i = math.random(#choices)
			end

			local new_nodename = choices[sync_i]
			if src ~= new_nodename then
				replacements[src] = new_nodename
			end
		end

		for src, choices in pairs(replacement_map.random or {}) do
			local new_nodename = choices[math.random(#choices)]
			if src ~= new_nodename then
				replacements[src] = new_nodename
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
	replace = replacement_randomizer({
		sync = {
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
		random = {
			["eco:jungle_wood"] = {
				"eco:jungle_wood",
				"eco:oak_wood"
			}
		}
	}),
	groups = {
		house = true
	},
	overview = "eco:slab_baked_clay_white"
})
