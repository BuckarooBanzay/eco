
--[[
Basic mapgen type

* Size: x=4, y=1, z=1
  * `(0,0,0)` = full block
  * `(1,0,0)` = inner slope
  * `(2,0,0)` = slope
  * `(3,0,0)` = outer slope

--]]

eco_api.register_placement("mapgen_v1", {
    place = function(template, mapblock_pos, options)
        local catalog, err = mapblock_lib.get_catalog(template.zip_file_path)
        if err then
            -- something went wrong
            return true, "Error reading zip catalog: " .. err
        end

        assert(options)

        -- TODO: error handling
        catalog:deserialize_all(mapblock_pos)
    end
})