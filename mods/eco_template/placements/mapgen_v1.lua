
--[[
Basic mapgen type

* Size: x=4, y=1, z=2
  * `(0,0,0)` = full block
  * `(1,0,0)` = inner slope
  * `(2,0,0)` = slope
  * `(3,0,0)` = outer slope

  *  (0,0,1) = underground block
  *  (0,0,2) = water block
--]]

eco_api.register_placement("mapgen_v1", {
    description = "Mapgen placement v1",
    check_size = function(size)
        return size.x == 4 and size.y == 1 and size.z == 2
    end,
    place = function(template, mapblock_pos, options)
        local catalog, err = mapblock_lib.get_catalog(template.zip_filename)
        if err then
            -- something went wrong
            return true, "Error reading zip catalog: " .. err
        end

        assert(options)

        -- TODO: error handling
        catalog:deserialize_all(mapblock_pos)
    end
})

--[[
eco_mapgen.mapgen = building_lib.create_mapgen({
    biomes = {
        {
            name = "default",
            temperature = 40,
            humidity = 50,
            buildings = {
                underground = "eco_mapgen:terrain_underground",
                surface = "eco_mapgen:terrain_surface",
                slope = "eco_mapgen:terrain_slope",
                slope_inner = "eco_mapgen:terrain_slope_inner",
                slope_outer = "eco_mapgen:terrain_slope_outer",
                water = "eco_mapgen:water"
            }
        }
    },
    from_y = -5,
    to_y = 10,
    water_level = 0
})

minetest.register_on_generated(eco_mapgen.mapgen.on_generated)
--]]