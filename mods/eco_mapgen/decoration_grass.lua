local MP = minetest.get_modpath("eco_mapgen")

local angles = {0, 90, 180, 270}

eco_mapgen.register_decoration({
	render = function(mapblock_pos, info, height, biome)
		if biome and biome.name == "grass" and info.type == "flat" and height > 2 then

			local path = MP .. "/schematics/decorations/grass_with_tree_" .. math.random(4)
			mapblock_lib.deserialize(mapblock_pos, path, {
				use_cache = true,
				mode = "add",
				transform = {
					rotate = {
						axis = "y",
						angle = angles[math.random(#angles)]
					}
				}
			})
		end
	end
})
