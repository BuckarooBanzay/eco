local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_biome("underground", {
	match = function(_, info)
		return info.type == "underground"
	end,

	full = MP .. "/schematics/base/stone_full"
})
