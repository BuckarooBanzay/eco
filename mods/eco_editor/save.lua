
function eco_editor.save(editor_origin_pos, player)
    local save_button_pos = vector.add(editor_origin_pos, eco_editor.button_offsets.save)
    local meta = core.get_meta(save_button_pos)

    local mapblock_pos = core.string_to_pos(meta:get_string("origin_mapblock_pos"))
    local template_size = core.string_to_pos(meta:get_string("template_size"))
    local template_name = meta:get_string("template_name")

    if eco_editor.operation_active[core.pos_to_string(mapblock_pos)] then
        core.chat_send_player(player:get_player_name(),"Operation still in progress, please await completion first")
        return
    end
    -- lock operations
    eco_editor.operation_active[core.pos_to_string(mapblock_pos)] = true

    local template = assert(eco_api.get_template(template_name))
    local eco_manifest = template.manifest

    -- save rotation config
    eco_manifest.disable_orientation = {}
    local rotation_meta = core.get_meta(vector.add(editor_origin_pos, eco_editor.button_offsets.configure_rotation))
    local rotation_inv = rotation_meta:get_inventory()
    for _, item in ipairs(rotation_inv:get_list("disable_orientation")) do
        if not item:is_empty() then
            eco_manifest.disable_orientation[item:get_name()] = true
        end
    end

    local zip_filename = eco_api.world_template_path .. "/" .. template_name .. ".zip"

    local mapblock_pos1 = vector.add(mapblock_pos, 1)
    local mapblock_pos2 = vector.add(mapblock_pos1, vector.add(template_size, -1))

    local options = {
        delay = 0,
        progress_callback = function(p)
            meta = core.get_meta(save_button_pos)
            meta:set_string("infotext", "Saving: " .. math.floor(p*100) .. "%")
        end
    }
    core.chat_send_player(player:get_player_name(), "Starting to save template '" .. template_name .. "'")
    local f = io.open(zip_filename, "wb")
    local z = mtzip.zip(f)

    Promise.async(function(await)
        await(mapblock_lib.serialize_area_to_zip(z, mapblock_pos1, mapblock_pos2, options))

        z:add("eco.json", core.write_json(eco_manifest))
        z:close()
        f:close()

        -- reload templates from world path
        eco_api.register_template_path(eco_api.world_template_path)

        core.chat_send_player(player:get_player_name(), "Template saved in '" .. zip_filename .. "'")
        meta = core.get_meta(save_button_pos)
        meta:set_string("infotext", "Save")

        -- unlock operations
        eco_editor.operation_active[core.pos_to_string(mapblock_pos)] = false
    end)
end