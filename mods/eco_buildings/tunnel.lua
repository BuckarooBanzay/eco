local MP = minetest.get_modpath("eco_buildings")

minetest.register_craftitem("eco_buildings:tunnel", {
	description = "Simple tunnel",
	inventory_image = "eco_buildings_inv_street.png",
	eco = {
		place_building = "eco_buildings:tunnel"
	}
})

building_lib.register({
	name = "eco_buildings:tunnel",
	placement = "slope",
	groups = {
		street = true
	},
	conditions = {
		{ not_on_biome = "water", on_slope_lower = true }
	},
	schematics = {
		slope_lower = MP .. "/schematics/tunnel/tunnel_entry"
	}
})
