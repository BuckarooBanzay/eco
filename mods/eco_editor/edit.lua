
core.register_chatcommand("eco_edit", {
    params = "<template-name>",
    description = "Edit a template",
    func = function(name, params)
        local template = eco_api.get_template(params)
        if not template then
            return true, "Template '" .. params .. "' not found"
        end

        -- TODO: find an unoccupied area and use that
        local player = core.get_player_by_name(name)
        local pos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(pos)

        -- local template to edit
        local catalog, err = mapblock_lib.get_catalog(template.zip_file_path)
        if err then
            -- something went wrong
            return true, "Error reading zip catalog: " .. err
        end

        -- place editor
        local editor_template = assert(eco_api.get_template("editor"))
        editor_template.place(mapblock_pos, {
            size = vector.add(catalog:get_size(), 2)
        })

        -- place buttons
        local min = mapblock_lib.get_mapblock_bounds_from_mapblock(mapblock_pos)
        local button_pos = vector.add(min, {x=10, y=10, z=0})

        -- save
        core.set_node(button_pos, {name="eco_editor:button_save"})
        local meta = core.get_meta(button_pos)
        meta:set_string("origin_mapblock_pos", core.pos_to_string(mapblock_pos))
        meta:set_string("template_size", core.pos_to_string(catalog:get_size()))
        meta:set_string("template_name", params)

        -- exit
        button_pos = vector.add(min, {x=12, y=10, z=0})
        core.set_node(button_pos, {name="eco_editor:button_exit"})
        meta = core.get_meta(button_pos)
        meta:set_string("origin_mapblock_pos", core.pos_to_string(mapblock_pos))
        meta:set_string("template_size", core.pos_to_string(catalog:get_size()))
        meta:set_string("template_name", params)

        -- place template to edit (offset by +1 in every axis)
        local _
        _, err = catalog:deserialize_all(vector.add(mapblock_pos, 1), {
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
    end
})

-- TODO: /eco_create <template-name>
-- TODO: /eco_remove <template-name>
