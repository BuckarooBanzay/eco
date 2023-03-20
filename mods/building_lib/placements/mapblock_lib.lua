
-- mapblock_lib schematic catalog
building_lib.register_placement("mapblock_lib", {
	place = function(self, mapblock_pos, building_def, replacements, rotation, callback)
		callback = callback or function() end

		local catalog
		local offset = {x=0, y=0, z=0}
		local cache = false

		if type(building_def.catalog) == "table" then
			catalog = mapblock_lib.get_catalog(building_def.catalog.filename)
			offset = building_def.catalog.offset or {x=0, y=0, z=0}
			cache = building_def.catalog.cache
		else
			catalog = mapblock_lib.get_catalog(building_def.catalog)
		end

		if cache and building_def._cache and building_def._cache[rotation] then
			-- rotated building already cached
			building_def._cache[rotation](mapblock_pos)
			callback()
			return
		else
			-- initialize cache if not already done
			building_def._cache = building_def._cache or {}
		end

		local size = self.get_size(self, mapblock_pos, building_def, 0)

		local catalog_pos1 = vector.add({x=0, y=0, z=0}, offset)
		local catalog_pos2 = vector.add(catalog_pos1, vector.add(size, -1))

		local iterator = mapblock_lib.pos_iterator(catalog_pos1, catalog_pos2)

		local function worker()
			local catalog_pos = iterator()
			if not catalog_pos then
				return callback()
			end

			-- transform catalog position relative to offset
			local rel_pos = vector.subtract(catalog_pos, offset)
			local max_pos = vector.subtract(catalog_pos2, offset)
			local rotated_rel_catalog_pos = mapblock_lib.rotate_pos(rel_pos, max_pos, rotation)

			-- translate to world-coords
			local world_pos = vector.add(mapblock_pos, rotated_rel_catalog_pos)

			local place_fn = catalog:prepare(catalog_pos, {
				on_metadata = building_def.on_metadata,
				transform = {
					rotate = {
						axis = "y",
						angle = rotation,
						disable_orientation = building_def.disable_orientation
					},
					replace = replacements
				}
			})

			-- cache prepared mapblock if enabled
			if cache then
				-- verify size constraints for caching
				assert(vector.equals(size, {x=1, y=1, z=1}))
				building_def._cache[rotation] = place_fn
			end

			if place_fn then
				-- only place if possible (mapblock found in catalog)
				place_fn(world_pos)
			end
			minetest.after(0, worker)
		end

		worker()
	end,

	get_size = function(_, _, building_def, rotation)
		local size
		if type(building_def.catalog) == "table" then
			size = building_def.catalog.size or {x=1, y=1, z=1}
		else
			local catalog = mapblock_lib.get_catalog(building_def.catalog)
			size = catalog:get_size()
		end
		return mapblock_lib.rotate_size(size, rotation)
	end,

	validate = function(_, building_def)
		local catalogfilename = building_def.catalog
		if type(building_def.catalog) == "table" then
			catalogfilename = building_def.catalog.filename
		end

		local catalog, err = mapblock_lib.get_catalog(catalogfilename)
		if catalog then
			return true
		else
			return false, err
		end
	end
})
