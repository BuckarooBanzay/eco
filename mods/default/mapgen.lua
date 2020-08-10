--
-- Aliases for map generators
--

-- All mapgens

minetest.register_alias("mapgen_stone", "default:stone")
minetest.register_alias("mapgen_water_source", "default:water_source")
minetest.register_alias("mapgen_river_water_source", "default:river_water_source")

--
-- Detect mapgen to select functions
--

minetest.clear_registered_biomes()
minetest.clear_registered_ores()
minetest.clear_registered_decorations()
