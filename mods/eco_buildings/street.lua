local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:street", {
	description = "Simple street",
	inventory_image = "eco_buildings_inv_street.png",
	eco = {
		place_building = "eco_buildings:street",
		place_on = function(mapblock_pos, _, mapgen_info)
			local _, biome_name = eco_mapgen.get_biome(mapblock_pos)

			local mapgen_matches = mapgen_info and (mapgen_info.type == "flat" or mapgen_info.type == "slope_lower")
			local biome_matches = biome_name == "grass" or biome_name == "snow"
			if not mapgen_matches then
				return false, "landscape not supported"
			elseif not biome_matches then
				return false, "biome not supported"
			else
				return true
			end
		end
	}
})

building_lib.register({
	name = "eco_buildings:street",
	placement = "connected",
	groups = {
		street = true
	},
	schematics = {
		straight = MP .. "/schematics/street/street_straight",
		all_sides = MP .. "/schematics/street/street_all_sides",
		corner = MP .. "/schematics/street/street_corner",
		three_sides = MP .. "/schematics/street/street_three_sides",
		slope_lower = MP .. "/schematics/street/street_slope_lower",
		slope_upper = MP .. "/schematics/street/street_slope_upper",
	}
})
