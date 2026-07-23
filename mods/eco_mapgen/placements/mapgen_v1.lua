
--[[
Basic mapgen type

* Size: x=4, y=1, z=2
  * `(0,0,0)` = full block
  * `(1,0,0)` = inner slope
  * `(2,0,0)` = slope
  * `(3,0,0)` = outer slope

  *  (0,0,1) = underground block
  *  (1,0,1) = water block
--]]

local part_mapping = {
    surface = {x=0, y=0, z=0},
    slope_inner = {x=1, y=0, z=0},
    slope = {x=2, y=0, z=0},
    slope_outer = {x=3, y=0, z=0},

    underground = {x=0, y=0, z=1},
    water = {x=1, y=0, z=1},
}

eco_api.register_placement("mapgen_v1", {
    description = "Mapgen placement v1",
    check_size = function(size)
        return size.x == 4 and size.y == 1 and size.z == 2
    end,
    place = function(template, mapblock_pos, options)
        assert(options)
        assert(options.partname)
        assert(options.rotation)
        assert(mapblock_pos)

        local cache_key = options.partname .. "/" .. options.rotation
        template._cache = template._cache or {}
        local cached_placement = template._cache[cache_key]
        if not cached_placement then
            -- create cache entry
            local catalog, err = mapblock_lib.get_catalog(template.zip_filename)
            if err then
                -- something went wrong
                return Promise.reject("Error reading zip catalog: " .. err)
            end

            local catalog_pos = assert(part_mapping[options.partname])
            local mapblock_options = {
                transform = {
                    rotate = {
                        angle = options.rotation,
                        axis = "y",
                        disable_orientation = template.manifest.disable_orientation
                    }
                }
            }
            cached_placement = catalog:prepare(catalog_pos, mapblock_options)
            template._cache[cache_key] = cached_placement
        end

        cached_placement(mapblock_pos)
        return Promise.resolve()
    end,
    remove = function(_, mapblock_pos)
        mapblock_lib.clear_mapblock(mapblock_pos)
    end
})
