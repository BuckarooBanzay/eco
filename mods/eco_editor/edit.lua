
core.register_chatcommand("eco_edit", {
    params = "<template-name>",
    description = "Edit a template",
    func = function(name, params)
        local template = eco_api.get_template(params)
        if not template then
            return true, "Template '" .. params .. "' not found"
        end

        local player = core.get_player_by_name(name)
        local pos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(pos)

        local catalog, err = mapblock_lib.get_catalog(template.zip_file_path)
        if err then
            -- something went wrong
            return true, "Error reading zip catalog: " .. err
        end

        local _
        _, err = catalog:deserialize_all(mapblock_pos, {
            callback = function()
                core.chat_send_player(name, "Template successfully read")
            end,
            error_callback = function(import_err)
                core.chat_send_player(name, "Deserialization failed: " .. import_err)
            end
        })

        if err then
            return true, "Deserialize failed: " .. err
        end
        -- TODO: editor stuff
    end
})

-- TODO: /eco_create <template-name>
-- TODO: /eco_remove <template-name>
