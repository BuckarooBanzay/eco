local MP = minetest.get_modpath("eco_buildings")

-- eco:silver_sandstone_brick_colorable
-- eco:slope_baked_clay_white_half_raised
-- eco:slope_baked_clay_white_half
-- eco:jungle_wood

local replacements = {
	{
		["eco:slope_baked_clay_white_half_raised"] = "eco:slope_baked_clay_blue_half_raised",
		["eco:slope_baked_clay_white_half"] = "eco:slope_baked_clay_blue_half",
		["eco:baked_clay_white"] = "eco:baked_clay_blue",
		["eco:jungle_wood"] = "eco:acacia_wood"
	},{
		["eco:slope_baked_clay_white_half_raised"] = "eco:slope_baked_clay_green_half_raised",
		["eco:slope_baked_clay_white_half"] = "eco:slope_baked_clay_green_half",
		["eco:baked_clay_white"] = "eco:baked_clay_green",
		["eco:jungle_wood"] = "eco:oak_wood"
	}
}

building_lib.register_building("eco_buildings:house_1", {
	catalog = MP .. "/schematics/house_1.zip",
	conditions = {
		{
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		}
	},
	replace = function()
		return replacements[math.random(#replacements)]
	end,
	groups = {
		house = true
	},
	overview = "eco:slab_baked_clay_white"
})
