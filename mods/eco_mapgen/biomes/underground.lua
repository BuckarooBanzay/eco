local MP = minetest.get_modpath("eco_mapgen")

-- TODO: this biome has only 1 used mapblock, the others just take up ram
eco_mapgen.register_biome({
	name = "underground",
	match = function(_, info)
		return info.type == "underground"
	end,
	catalog = MP .."/schematics/mapgen_grass.zip"
})
