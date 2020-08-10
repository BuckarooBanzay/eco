local S = minetest.get_translator("eco_basenodes")

minetest.register_node("eco_basenodes:stone", {
	description = S("Stone"),
	tiles = {"eco_basenodes_stone.png"},
	groups = {cracky = 3, stone = 1}
})

minetest.register_node("eco_basenodes:dirt", {
	description = S("Dirt"),
	tiles = {"eco_basenodes_dirt.png"},
	groups = {crumbly = 3, soil = 1}
})

minetest.register_node("eco_basenodes:dirt_with_grass", {
	description = S("Dirt with Grass"),
	tiles = {
    "eco_basenodes_grass.png",
    "eco_basenodes_dirt.png",
		{
      name = "eco_basenodes_dirt.png^eco_basenodes_grass_side.png",
			tileable_vertical = false
    }
  },
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1}
})
