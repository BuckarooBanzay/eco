local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:house", {
	description = "Simple house",
	inventory_image = "default_mese_crystal.png",
	eco = {
		place_building = "eco_buildings:house",
		-- TODO: deprecate
		place_on = {
			mapgen_type = {"flat"},
			biome = {"grass", "snow"}
		}
	}
})

building_lib.register({
	name = "eco_buildings:house",
	placement = "simple",
	placement_flags = {
		on_flat_surface = true
	},
	schematic = MP .. "/schematics/house"
})
