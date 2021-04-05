local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:stone_block", {
	description = "Stone block",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_building = "eco_buildings:stone_block"
	}
})

building_lib.register({
	name = "eco_buildings:stone_block",
	placement = "simple",
	placement_flags = {
		on_slope_lower = true,
		on_flat_surface = true
	},
	groups = {
		support = true
	},
	schematic = MP .. "/schematics/stone_full"
})

building_lib.register_placement_flag({
    name = "on_flat_surface",
    can_build = function(mapblock_pos)
		local mapgen_info = eco_mapgen.get_info(mapblock_pos)
		local mapgen_matches = mapgen_info and mapgen_info.type == "flat"
		if not mapgen_matches then
			return false, "landscape not supported"
		else
			return true
		end
    end
})

building_lib.register_placement_flag({
    name = "on_slope_lower",
    can_build = function(mapblock_pos)
		local mapgen_info = eco_mapgen.get_info(mapblock_pos)
		local mapgen_matches = mapgen_info and mapgen_info.type == "slope_lower"
		if not mapgen_matches then
			return false, "landscape not supported"
		else
			return true
		end
    end
})