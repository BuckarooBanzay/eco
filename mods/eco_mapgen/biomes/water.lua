local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome({
	name = "water",
	match = function(mapblock_pos, info)
		return mapblock_pos.y < 0 and info.type ~= "underground"
	end,
	catalog = MP .."/schematics/terrain.zip",

	replace = {
		["air"] = "eco:water_source",
		["eco:stone"] = "eco:water_source",
		["eco:slope_stone"] = "eco:water_source",
		["eco:slope_stone_inner"] = "eco:water_source",
		["eco:slope_stone_outer"] = "eco:water_source"
	}
})
