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
		run = function(mapblock_pos)
			local resources = eco_mapgen.count_resources(mapblock_pos, 1)
			local trees = resources.trees or 0
			print(dump(mapblock_pos), trees)
		end
	}
})
