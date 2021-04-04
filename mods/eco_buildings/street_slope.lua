local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:street_slope", {
	description = "Simple sloped street",
	inventory_image = "eco_buildings_inv_street.png",
	eco = {
		place_building = "eco_buildings:street_slope"
	}
})

building_lib.register({
	name = "eco_buildings:street_slope",
	placement = "slope",
	groups = {
		street = true
	},
	can_build = function(mapblock_pos)
		-- check for biome and mapgen match
		local _, biome_name = eco_mapgen.get_biome(mapblock_pos)
		local mapgen_info = eco_mapgen.get_info(mapblock_pos)

		local mapgen_matches = mapgen_info and mapgen_info.type == "slope_lower"
		local biome_matches = biome_name == "grass" or biome_name == "snow"
		if not mapgen_matches then
			return false, "landscape not supported"
		elseif not biome_matches then
			return false, "biome not supported"
		else
			return true
		end
	end,
	schematics = {
		slope_lower = MP .. "/schematics/street/street_slope_lower",
		slope_upper = MP .. "/schematics/street/street_slope_upper"
	}
})
