local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:loading_dock", {
    description = "Loading dock",
    inventory_image = "default_mese_crystal.png",
    eco = {
      place_building = "eco_buildings:loading_dock"
    }
})

building_lib.register({
    name = "eco_buildings:loading_dock",
    placement = "simple",
    conditions = {
      { not_on_biome = "water", on_flat_surface = true }
    },
    connections = {
      street = {"x-"}
    },
    schematic = MP .. "/schematics/loading_dock/loading_dock"
})
