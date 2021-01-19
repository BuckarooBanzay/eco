local function select_schematic(schema_def, mapblock)
	if type(schema_def) == "string" then
		return schema_def
	elseif type(schema_def) == "table" then
		return schema_def[math.random(#schema_def)]
	elseif type(schema_def) == "function" then
		return schema_def(mapblock)
	end
end

local function place_biome_mapblock(mapblock, biome)
	local info = eco_mapgen.get_info(mapblock)
	local pos = mapblock_lib.get_mapblock_bounds_from_mapblock(mapblock)

	-- add mapgen info (if available) to grid data
	if info.type ~= "none" then
		-- only save if data available
		mapblock_lib.set_mapblock(mapblock, {
			mapgen = {
				biome_key = biome.key,
				terrain_type = info.type,
				terrain_direction = info.direction
			}
		})
	end

	if info.type == "flat" and biome.schemas.flat then
		local rotations = {0, 90, 180, 270}
		local schematic_dir, options = select_schematic(biome.schemas.flat, mapblock)
		options = options or {
			use_cache = true,
			transform = {
				rotate = {
		      axis = "y",
		      angle = rotations[math.random(#rotations)]
		    }
			}
		}

		mapblock_lib.deserialize(pos, schematic_dir, options)

	elseif info.type == "slope" and biome.schemas.slope then
		-- slope looks into z+ direction
		local rotate = nil
		if info.direction == "z-" then
			rotate = { axis = "y", angle = 180 }
		elseif info.direction == "x+" then
			rotate = { axis = "y", angle = 90 }
		elseif info.direction == "x-" then
			rotate = { axis = "y", angle = 270 }
		end

		mapblock_lib.deserialize(pos, select_schematic(biome.schemas.slope, mapblock), {
			use_cache = true,
			sync = true,
			transform = {
				rotate = rotate
			}
		})

	elseif info.type == "slope_inner" and biome.schemas.slope_inner then
		-- slope looks into x-z+ direction
		local rotate = nil
		if info.direction == "x-z-" then
			rotate = { axis = "y", angle = 270 }
		elseif info.direction == "x+z-" then
			rotate = { axis = "y", angle = 180 }
		elseif info.direction == "x+z+" then
			rotate = { axis = "y", angle = 90 }
		end

		mapblock_lib.deserialize(pos, select_schematic(biome.schemas.slope_inner, mapblock), {
			use_cache = true,
			sync = true,
			transform = {
				rotate = rotate
			}
		})

	elseif info.type == "slope_outer" and biome.schemas.slope_outer then
		-- slope looks into x-z+ direction
		local rotate = nil
		if info.direction == "x-z-" then
			rotate = { axis = "y", angle = 270 }
		elseif info.direction == "x+z-" then
			rotate = { axis = "y", angle = 180 }
		elseif info.direction == "x+z+" then
			rotate = { axis = "y", angle = 90 }
		end

		mapblock_lib.deserialize(pos, select_schematic(biome.schemas.slope_outer, mapblock), {
			use_cache = true,
			sync = true,
			transform = {
				rotate = rotate
			}
		})

	elseif info.type == "none" and biome.schemas.empty then
		mapblock_lib.deserialize(pos, select_schematic(biome.schemas.empty, mapblock), {
			use_cache = true,
			sync = true
		})

	end

end

function eco_mapgen.place_mapblock(mapblock)
	local biome = nil
	for _, biome_def in pairs(eco_mapgen.get_biomes()) do
		if biome_def.match(mapblock) then
			biome = biome_def
			break
		end
	end

	if biome then
		place_biome_mapblock(mapblock, biome)
	end
	-- TODO: overwrite non-mapgen blocks with air
end

minetest.register_on_generated(function(minp, maxp)

	-- 5x5x5 mapblocks per chunk
	assert((maxp.x - minp.x + 1) == 80)

	local min_mapblock = mapblock_lib.get_mapblock(minp)
	local max_mapblock = mapblock_lib.get_mapblock(maxp)

	for z=min_mapblock.z,max_mapblock.z do
	for x=min_mapblock.x,max_mapblock.x do
	for y=min_mapblock.y,max_mapblock.y do

		local mapblock = { x=x, y=y, z=z }
		--eco_mapgen.place_mapblock(mapblock)

	end --y
	end --x
	end --z

end)
