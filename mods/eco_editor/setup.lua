
eco_editor.setup = Promise.asyncify(function(await, playername, templatename, template)
    -- TODO: find an unoccupied area and use that
    local player = core.get_player_by_name(playername)
    local pos = player:get_pos()
    local mapblock_pos = mapblock_lib.get_mapblock(pos)

    local catalog, err
    if core.path_exists(template.zip_filename) then
        -- only read catalog if there is a zip-file in the path
        -- could be missing if the template has just been set up in-world but not saved yet
        catalog, err = mapblock_lib.get_catalog(template.zip_filename)
        if err then
            -- something went wrong
            error("Error reading zip catalog: " .. err, 0)
        end
    end

    -- place editor
    local editor_template = assert(eco_api.get_template("editor"))
    local place_options = {
        size = vector.add(template.manifest.size, 2)
    }
    await(editor_template:place(mapblock_pos, place_options))

    -- place buttons
    local editor_origin_pos = mapblock_lib.get_mapblock_bounds_from_mapblock(mapblock_pos)

    -- exit
    local button_pos = vector.add(editor_origin_pos, eco_editor.button_offsets.exit)
    core.set_node(button_pos, {name="eco_editor:button_exit"})
    local meta = core.get_meta(button_pos)
    meta:set_string("origin_mapblock_pos", core.pos_to_string(mapblock_pos))
    meta:set_string("template_size", core.pos_to_string(template.manifest.size))
    meta:set_string("template_name", templatename)

    -- save
    button_pos = vector.add(editor_origin_pos, eco_editor.button_offsets.save)
    core.set_node(button_pos, {name="eco_editor:button_save"})
    meta = core.get_meta(button_pos)
    meta:set_string("editor_origin_pos", core.pos_to_string(editor_origin_pos))
    meta:set_string("origin_mapblock_pos", core.pos_to_string(mapblock_pos))
    meta:set_string("template_size", core.pos_to_string(template.manifest.size))
    meta:set_string("template_name", templatename)
    meta:set_string("placement_name", template.manifest.placement)

    -- toggle light
    button_pos = vector.add(editor_origin_pos, eco_editor.button_offsets.toggle_light)
    core.set_node(button_pos, {name="eco_editor:button_toggle_light"})

    -- configure placement
    button_pos = vector.add(editor_origin_pos, eco_editor.button_offsets.configure_placement)
    core.set_node(button_pos, {name="eco_editor:button_configure"})
    meta = core.get_meta(button_pos)
    meta:set_string("manifest", core.write_json(template.manifest))

    --[[
    -- configure rotation
    button_pos = vector.add(editor_origin_pos, eco_editor.button_offsets.configure_rotation)
    core.set_node(button_pos, {name="eco_editor:button_configure_rotation"})

    if template.manifest.disable_orientation then
        local rotation_meta = core.get_meta(vector.add(editor_origin_pos, eco_editor.button_offsets.configure_rotation))
        local rotation_inv = rotation_meta:get_inventory()
        local disable_orientation = {}
        for name in pairs(template.manifest.disable_orientation) do
            table.insert(disable_orientation, ItemStack(name))
        end
        rotation_inv:set_list("disable_orientation", disable_orientation)
    end

    if template.manifest.placement == "mapgen_v1" then
        -- configure mapgen
        button_pos = vector.add(editor_origin_pos, eco_editor.button_offsets.configure_mapgen)
        core.set_node(button_pos, {name="eco_editor:button_configure_mapgen"})
    end
    --]]

    -- place template to edit (offset by +1 in every axis)
    if catalog then
        await(catalog:deserialize_all(vector.add(mapblock_pos, 1)))
    end
end)