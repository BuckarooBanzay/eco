local MP = minetest.get_modpath("eco_buildings")

eco_api.register_building({
  name = "Simple house",
  cost = 25000,
  schema_dir = MP .. "/schemas/simple_house"
})
