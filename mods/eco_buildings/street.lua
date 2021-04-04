local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:street", {
	description = "Simple street",
	inventory_image = "eco_buildings_inv_street.png",
	eco = {
		place_building = "eco_buildings:street"
	}
})

-- TODO: move into util / lower layer
local below_neighbor_support_offsets = {
	{x=0, y=-1, z=0},
	{x=1, y=-1, z=0},
	{x=-1, y=-1, z=0},
	{x=0, y=-1, z=1},
	{x=0, y=-1, z=-1},
}

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
		-- allow placement if the neighbor mapblock or below is supported
		for _, offset in ipairs(below_neighbor_support_offsets) do
			local groups = building_lib.get_groups_at_pos(vector.add(mapblock_pos, offset))
			if groups.support then
				return true
			end
		end


		-- check for biome and mapgen match
		local _, biome_name = eco_mapgen.get_biome(mapblock_pos)
		local mapgen_info = eco_mapgen.get_info(mapblock_pos)

		local mapgen_matches = mapgen_info and mapgen_info.type == "flat"
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
		three_sides = MP .. "/schematics/street/street_three_sides"
	}
})
