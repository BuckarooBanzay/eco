local MP = minetest.get_modpath("eco_buildings")

eco_api.register_building({
  name = "Simple house",
  schema_dir = MP .. "/schemas/simple_house"
})
