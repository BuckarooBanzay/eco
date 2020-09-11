local MP = minetest.get_modpath("eco_streets")

eco_api.register_building({
  type = "street",
  key = "eco_streets:dirt_road",
  name = "Dirt road",
  description = "Fast and cheap dirt road",
  cost = 5000,
  destroy_cost = 1000,
  placement_type = "connected_street",
  connects_to = {
    "eco_streets:dirt_road",
    "eco_streets:stone_street",
    "eco_streets:stone_street_rails"
  },
  on_place = eco_placement.place_connected_street({
    {
      directions = {
        { x = 1, y = 0, z = 0 },
        { x = -1, y = 0, z = 0 }
      },
      schema = MP .. "/schematics/dirt_road_straight"
    },
    {
      directions = {
        { x = 1, y = 0, z = 0 },
        { x = 0, y = 0, z = 1 }
      },
      schema = MP .. "/schematics/dirt_road_corner"
    },
    {
      directions = {
        { x = 0, y = 0, z = -1 },
        { x = 0, y = 1, z = 1 }
      },
      schema = MP .. "/schematics/dirt_road_slope"
    },
    {
      directions = {
        { x = 1, y = 0, z = 0 },
        { x = -1, y = 0, z = 0 },
        { x = 0, y = 0, z = -1 }
      },
      schema = MP .. "/schematics/dirt_road_three_sides"
    },
    {
      directions = {
        { x = 1, y = 0, z = 0 },
        { x = 0, y = 0, z = 1 },
        { x = -1, y = 0, z = 0 },
        { x = 0, y = 0, z =-1 }
      },
      schema = MP .. "/schematics/dirt_road_all_sides"
    }
  })
})

--[[
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

eco_api.register_building({
  type = "street",
  key = "eco_streets:stone_street_rails",
  name = "Stone street with rails",
  description = "A simple street, made out of gravel and stone with rails on it",
  cost = 25000,
  destroy_cost = 7500,
  rails = {
    -- TODO: rails definition
    x = 6,
    y = 2,
    z = 0
  },
  influence = {
    noise = 0.1
  },
  schemas = {
    straight = MP .. "/schematics/street_with_rails_straight",
    corner = MP .. "/schematics/street_with_rails_corner",
    all_sides = MP .. "/schematics/street_with_rails_all_sides",
    slope = MP .. "/schematics/street_with_rails_slope",
    three_sides = MP .. "/schematics/street_with_rails_three_sides"
  },
  -- TODO: configurable orientation
  -- disable_orientation = true
})
--]]
