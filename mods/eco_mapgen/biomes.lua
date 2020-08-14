-- TODO match priority

eco_mapgen.register_biome({
  key = "water",
  match = function(mapblock)
    return mapblock.y <= eco_mapgen.get_water_height()
  end,
  generate = function(mapblock)
  end
})

eco_mapgen.register_biome({
  key = "grass",
  match = function(mapblock)
    return mapblock.y > eco_mapgen.get_water_height()
  end,
  generate = function(mapblock)
  end
})
