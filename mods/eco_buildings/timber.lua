local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:timber_plantation", {
	description = "Timer plantation",
	inventory_image = "default_wood.png",
	eco = {
		place_building = "eco_buildings:timber_plantation",
		place_on = {
			mapgen_type = {"flat"}
		}
	}
})

building_lib.register({
	name = "eco_buildings:timber_plantation",
	placement = "simple",
	schematic = MP .. "/schematics/timber_plantation",
	timer = {
		interval = 2,
		run = function(mapblock_pos, building_def)
			print(os.time(), dump(mapblock_pos), dump(building_def))
		end
	}
})
