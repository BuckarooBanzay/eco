local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:street", {
	description = "Simple street",
	inventory_image = "eco_buildings_inv_street.png",
	eco = {
		place_building = "eco_buildings:street"
	}
})

building_lib.register({
	name = "eco_buildings:street",
	placement = "connected",
	connects_to = {
		street = true
	},
	groups = {
		street = true
	},
	can_build = function(mapblock_pos)
		-- check if there is a building below with "support" group
		local groups_below = building_lib.get_groups_at_pos(vector.add(mapblock_pos, {x=0,y=-1,z=0}))
		if groups_below.support then
			return true
		end

		-- check for biome and mapgen match
		local _, biome_name = eco_mapgen.get_biome(mapblock_pos)
		local mapgen_info = eco_mapgen.get_info(mapblock_pos)

		local mapgen_matches = mapgen_info and (mapgen_info.type == "flat" or mapgen_info.type == "slope_lower")
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
		straight = MP .. "/schematics/street/street_straight",
		all_sides = MP .. "/schematics/street/street_all_sides",
		corner = MP .. "/schematics/street/street_corner",
		three_sides = MP .. "/schematics/street/street_three_sides",
		slope_lower = MP .. "/schematics/street/street_slope_lower",
		slope_upper = MP .. "/schematics/street/street_slope_upper",
	}
})
