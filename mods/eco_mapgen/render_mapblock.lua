local MP = minetest.get_modpath("eco_mapgen")
local catalog = mapblock_lib.get_catalog(MP .. "/schematics/terrain.zip")

local underground_full = catalog:prepare({x=0,y=0,z=0}, {
	transform = {
		replace = {
			["eco:cobble"] = "eco:stone"
		}
	}
})

local water_full = catalog:prepare({x=0,y=0,z=0}, {
	transform = {
		replace = {
			["eco:cobble"] = "eco:water_source",
			["eco:stone"] = "eco:water_source"
		}
	}
})

function eco_mapgen.render_mapblock(mapblock_pos)
	local info = eco_mapgen.get_info(mapblock_pos)
	local biome_data = eco_mapgen.get_biome_data(mapblock_pos)
	local biome = eco_mapgen.get_biome(mapblock_pos, info, biome_data)

	if mapblock_pos.y < biome_data.height then
		-- solid underground
		underground_full(mapblock_pos)
		return
	end

	if mapblock_pos.y < 0 then
		-- water
		water_full(mapblock_pos)
		return
	end

	if info.type == "full" then
		catalog:deserialize({x=0,y=0,z=0}, mapblock_pos, {
			transform = {
				replace = biome.replace
			}
		})
	elseif info.type == "slope" then
		catalog:deserialize({x=2,y=0,z=0}, mapblock_pos, {
			transform = {
				replace = biome.replace,
				rotate = {
					axis = "y",
					angle = info.rotation
				}
			}
		})
	elseif info.type == "slope_inner" then
		catalog:deserialize({x=1,y=0,z=0}, mapblock_pos, {
			transform = {
				replace = biome.replace,
				rotate = {
					axis = "y",
					angle = info.rotation
				}
			}
		})
	elseif info.type == "slope_outer" then
		catalog:deserialize({x=3,y=0,z=0}, mapblock_pos, {
			transform = {
				replace = biome.replace,
				rotate = {
					axis = "y",
					angle = info.rotation
				}
			}
		})
	end

end
