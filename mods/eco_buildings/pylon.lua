local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:pylon", {
	description = "Support pylon",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_building = "eco_buildings:pylon"
	}
})

building_lib.register({
	name = "eco_buildings:pylon",
	placement = "simple",
	schematic = MP .. "/schematics/pylon",
	groups = {
		support = true,
		stackable = true
	},
	can_build = function(mapblock_pos)
		local below_mapblock_pos = vector.add(mapblock_pos, {x=0, y=-1, z=0})

		-- check if mapblock below is a pylon
		local building = building_lib.get_building_at_pos(below_mapblock_pos)
		if building and building.name == "eco_buildings:pylon" then
			return true
		end

		-- check biome
		local _, biome_name = eco_mapgen.get_biome(mapblock_pos)
		local biome_matches = biome_name == "grass" or biome_name == "snow"
		if not biome_matches then
			return false, "wrong biome"
		end

		-- check the terrain type
		local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
		if not mapblock_data or not mapblock_data.mapgen_info then
			return false, "no data available"
		end

		local mapgen_info = mapblock_data.mapgen_info
		if mapgen_info.type ~= "flat" then
			return false, "not a flat terrain"
		end

		return true
	end
})
