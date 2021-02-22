local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:house", {
	description = "Simple house",
	inventory_image = "default_mese_crystal.png",
	building_lib = {
		place = "eco_buildings:house"
	}
})

building_lib.register({
	name = "eco_buildings:house",
	placement = "simple",
	schematic = MP .. "/schematics/house",
	can_build = function(mapblock_pos)
		-- TODO: check underground/biome stuff here
		print("can_build", dump(mapblock_pos)) --TODO
		return true
	end
})
