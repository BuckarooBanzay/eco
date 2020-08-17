local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome({
  key = "water",
  match = function(mapblock)
    local is_in_water = mapblock.y <= eco_mapgen.get_water_height()
    local map_height = eco_mapgen.get_mapblock_height(mapblock)

    return mapblock.y == map_height and is_in_water
  end,
  schemas = {
    flat = MP .. "/schematics/water_flat",
    slope = MP .. "/schematics/water_slope",
    slope_inner = MP .."/schematics/water_slope_inner_corner",
    slope_outer = MP .."/schematics/water_slope_outer_corner",
    empty = MP .. "/schematics/water_full"
  }
})
