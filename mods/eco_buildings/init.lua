local MP = minetest.get_modpath("eco_buildings")

eco_api.register_building({
  key = "eco_buildings:simple_house_low_density",
  name = "Simple house with low density population",
  description = "Simple house with low density population",
  cost = 25000,
  schemas = {
    MP .. "/schematics/simple_house_low_density"
  }
})

eco_api.register_building({
  key = "eco_buildings:simple_house_average_density",
  name = "Simple house with average density population",
  description = "Simple house with average density population",
  cost = 50000,
  schemas = {
    MP .. "/schematics/simple_house_average_density"
  }
})

eco_api.register_building({
  key = "eco_buildings:simple_house_high_density",
  name = "Simple house with high density population",
  description = "Simple house with high density population",
  cost = 75000,
  schemas = {
    MP .. "/schematics/simple_house_high_density"
  }
})
