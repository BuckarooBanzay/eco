local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_decoration({
	render = function(mapblock_pos, info, height, biome)
		if biome and biome.name == "grass" and info.type == "flat" and height > 2 then
			mapblock_lib.deserialize(mapblock_pos, MP .. "/schematics/decorations/grass_with_tree_1", {
				use_cache = true,
				mode = "add"
			})
		end
	end
})
