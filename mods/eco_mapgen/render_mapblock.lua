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

local water_level = -1

function eco_mapgen.render_mapblock(mapblock_pos)
	local biome_data = eco_mapgen.get_biome_data(mapblock_pos)
	local mapgen_info

	if mapblock_pos.y < biome_data.height or mapblock_pos.y < water_level then
		-- below biome-height or solid underground
		underground_full(mapblock_pos)
		mapgen_info = {
			solid = true
		}
	elseif mapblock_pos.y == water_level then
		-- water layer
		water_full(mapblock_pos)
		mapgen_info = {
			water = true
		}
	else
		-- render biomes
		local slope_info = eco_mapgen.get_slope_info(mapblock_pos)
		local biome = eco_mapgen.get_biome(mapblock_pos, slope_info, biome_data)

		if slope_info.type == "full" then
			catalog:deserialize({x=0,y=0,z=0}, mapblock_pos, {
				transform = {
					replace = biome.replace
				}
			})
			mapgen_info = {
				solid = true
			}
		elseif slope_info.type == "slope" then
			catalog:deserialize({x=2,y=0,z=0}, mapblock_pos, {
				transform = {
					replace = biome.replace,
					rotate = {
						axis = "y",
						angle = slope_info.rotation
					}
				}
			})
			mapgen_info = {
				slope = true,
				rotation = slope_info.rotation
			}
		elseif slope_info.type == "slope_inner" then
			catalog:deserialize({x=1,y=0,z=0}, mapblock_pos, {
				transform = {
					replace = biome.replace,
					rotate = {
						axis = "y",
						angle = slope_info.rotation
					}
				}
			})
			mapgen_info = {
				slope = true,
				slope_inner = true,
				rotation = slope_info.rotation
			}
		elseif slope_info.type == "slope_outer" then
			catalog:deserialize({x=3,y=0,z=0}, mapblock_pos, {
				transform = {
					replace = biome.replace,
					rotate = {
						axis = "y",
						angle = slope_info.rotation
					}
				}
			})
			mapgen_info = {
				slope = true,
				slope_outer = true,
				rotation = slope_info.rotation
			}
		else
			-- nothing to render
			return
		end
	end

	if mapgen_info then
		eco_data:merge(mapblock_pos, {
			mapgen_info = mapgen_info
		})
	end
end

function eco_mapgen.get_info(mapblock_pos)
	local data = eco_data:get(mapblock_pos)
	if not data then
		return {}
	end

	return data.mapgen_info or {}
end