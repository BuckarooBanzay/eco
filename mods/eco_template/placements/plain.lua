
--[[
plain placement
--]]

eco_api.register_placement("plain", {
    description = "simple placement",
    check_size = function()
        return true
    end,
    get_configuration = function()
        return {}
    end,
    place = function(template, mapblock_pos)
        local catalog, err = mapblock_lib.get_catalog(template.zip_filename)
        if err then
            -- something went wrong
            return Promise.reject("Error reading zip catalog: " .. err)
        end

        return Promise.async(function(await)
            await(catalog:deserialize_all(mapblock_pos))
            return {
                size = catalog:get_size()
            }
        end)
    end,
    remove = function(_, mapblock_pos1, mapblock_data)
    local mapblock_pos2 = vector.add(mapblock_pos1, vector.add(mapblock_data.size, -1))
        for mapblock_pos in mapblock_lib.pos_iterator(mapblock_pos1, mapblock_pos2) do
            mapblock_lib.clear_mapblock(mapblock_pos)
        end
    end
})