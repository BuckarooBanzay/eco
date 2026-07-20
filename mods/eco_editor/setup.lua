
function eco_editor.setup(playername, templatename)
    -- TODO: find an unoccupied area and use that
    local player = core.get_player_by_name(playername)
    local pos = player:get_pos()
    local mapblock_pos = mapblock_lib.get_mapblock(pos)

    -- local template to edit
    local template = eco_api.get_template(templatename)
    local catalog, err = mapblock_lib.get_catalog(template.zip_filename)
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
    local button_pos = vector.add(min, {x=10, y=20, z=0})

    -- save
    core.set_node(button_pos, {name="eco_editor:button_save"})
    local meta = core.get_meta(button_pos)
    meta:set_string("origin_mapblock_pos", core.pos_to_string(mapblock_pos))
    meta:set_string("template_size", core.pos_to_string(catalog:get_size()))
    meta:set_string("template_name", templatename)

    -- exit
    button_pos = vector.add(button_pos, {x=2, y=0, z=0})
    core.set_node(button_pos, {name="eco_editor:button_exit"})
    meta = core.get_meta(button_pos)
    meta:set_string("origin_mapblock_pos", core.pos_to_string(mapblock_pos))
    meta:set_string("template_size", core.pos_to_string(catalog:get_size()))
    meta:set_string("template_name", templatename)

    -- toggle light
    button_pos = vector.add(button_pos, {x=2, y=0, z=0})
    core.set_node(button_pos, {name="eco_editor:button_toggle_light"})

    -- configure placement
    button_pos = vector.add(button_pos, {x=2, y=0, z=0})
    core.set_node(button_pos, {name="eco_editor:button_configure_placement"})

    -- place template to edit (offset by +1 in every axis)
    local _
    _, err = catalog:deserialize_all(vector.add(mapblock_pos, 1), {
        callback = function()
            core.chat_send_player(playername, "Template successfully read")
        end,
        error_callback = function(import_err)
            core.chat_send_player(playername, "Deserialization failed: " .. import_err)
        end
    })

    if err then
        return true, "Deserialize failed: " .. err
    end
end