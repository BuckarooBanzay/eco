local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:strut", {
	catalog = MP .. "/schematics/strut.zip",
	conditions = {
		{
			-- flat surface
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		},{
			-- in water
			["*"] = { group = "water" },
			["underground"] = { group = "flat_surface" }
		},{
			-- stacked
			["*"] = { empty = true },
			["underground"] = { group = "support"}
		}
	},
	remove_conditions = {
		{["above"] = { empty = true }}
	},
	groups = {
		strut = true,
		support = true
	},
	replace = function(mapblock_pos)
		if eco_mapgen.mapgen and eco_mapgen.mapgen.is_water(mapblock_pos) then
			return {
				["air"] = "eco:water_source"
			}
		end
	end,
	overview = "eco:silver_sandstone_brick"
})