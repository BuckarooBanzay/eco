local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:stone_block", {
    description = "Stone block",
    inventory_image = "default_mese_crystal.png",
    eco = {
      place_building = "eco_buildings:stone_block"
    }
})

building_lib.register({
    name = "eco_buildings:stone_block",
    placement = "simple",
    conditions = {
      { on_mapgen_type = "slope_lower" },
      { on_mapgen_type = "slope_inner_lower" },
      { on_mapgen_type = "slope_outer_lower" },
      { on_mapgen_type = "flat" },
    },
    groups = {
      support = true
    },
    schematic = MP .. "/schematics/stone_full"
})
