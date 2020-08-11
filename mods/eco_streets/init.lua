local MP = minetest.get_modpath("eco_streets")

eco_api.register_street({
  name = "Stone street",
  cost = 15000,
  schemas = {
    straight = MP .. "/schemas/street_straight",
    corner = MP .. "/schemas/street_corner",
    all_sides = MP .. "/schemas/street_all_sides",
    three_sides = MP .. "/schemas/street_three_sides"
  }
})
