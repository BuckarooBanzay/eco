
--[[
plain placement
--]]

eco_api.register_placement("plain", {
    description = "simple placement",
    check_size = function()
        return true
    end,
    place = function(template, mapblock_pos)
        local catalog, err = mapblock_lib.get_catalog(template.zip_filename)
        if err then
            -- something went wrong
            return Promise.reject("Error reading zip catalog: " .. err)
        end

        return catalog:deserialize_all(mapblock_pos)
    end
})