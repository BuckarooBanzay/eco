local MP = minetest.get_modpath("eco_streets")

eco_api.register_building({
  type = "street",
  key = "eco_streets:dirt_road",
  name = "Dirt road",
  description = "Fast and cheap dirt road",
  cost = 5000,
  destroy_cost = 1000,
  schemas = {
    straight = MP .. "/schematics/dirt_road_straight",
    corner = MP .. "/schematics/dirt_road_corner",
    all_sides = MP .. "/schematics/dirt_road_all_sides",
    slope = MP .. "/schematics/dirt_road_slope",
    three_sides = MP .. "/schematics/dirt_road_three_sides"
  }
})

eco_api.register_building({
  type = "street",
  key = "eco_streets:stone_street",
  name = "Stone street",
  description = "A simple street, made out of gravel and stone",
  cost = 15000,
  destroy_cost = 5000,
  influence = {
    noise = 0.1
  },
  schemas = {
    straight = MP .. "/schematics/street_straight",
    corner = MP .. "/schematics/street_corner",
    all_sides = MP .. "/schematics/street_all_sides",
    slope = MP .. "/schematics/street_slope",
    three_sides = MP .. "/schematics/street_three_sides"
  },
  disable_orientation = true
})
