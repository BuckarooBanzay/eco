local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:stone_quarry", {
	catalog = MP .. "/schematics/stone_quarry.zip",
	conditions = {
		{
			["(1,1,0)"] = { empty = true },
			["(1,1,1)"] = { empty = true },
			["(0,1,1)"] = { empty = true },
			["(0,1,0)"] = { empty = true },
			["(0,0,0)"] = { group = "flat_surface" },
			["(1,0,0)"] = { group = "flat_surface" },
			["(1,0,1)"] = { group = "flat_surface" },
			["(0,0,1)"] = { group = "flat_surface" }
		}
	},
	groups = {
		quarry = true
	},
	overview = function(rel_mapblock_pos)
		if rel_mapblock_pos.y == 0 then
			return { name="eco:slab_cobble_quarter" }
		end
	end
})