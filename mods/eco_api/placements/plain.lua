
--[[
plain placement
--]]

eco_api.register_placement("plain", {
    place = function(template, mapblock_pos)
        local catalog, err = mapblock_lib.get_catalog(template.zip_file_path)
        if err then
            -- something went wrong
            return true, "Error reading zip catalog: " .. err
        end

        -- TODO: error handling
        catalog:deserialize_all(mapblock_pos)
    end
})