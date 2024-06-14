
eco_mapgen.mapgen = building_lib.create_mapgen({
    biomes = {
        {
            name = "default",
            temperature = 40,
            humidity = 50,
            buildings = {
                underground = "eco_mapgen:terrain_underground",
                surface = "eco_mapgen:terrain_surface",
                slope = "eco_mapgen:terrain_slope",
                slope_inner = "eco_mapgen:terrain_slope_inner",
                slope_outer = "eco_mapgen:terrain_slope_outer",
                water = "eco_mapgen:water"
            }
        }
    },
    from_y = -5,
    to_y = 10,
    water_level = 0
})

minetest.register_on_generated(eco_mapgen.mapgen.on_generated)
minetest.register_alias("mapgen_stone", "eco:stone")
minetest.register_alias("mapgen_water_source", "eco:water_source")