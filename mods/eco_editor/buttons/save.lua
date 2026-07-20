
core.register_node("eco_editor:button_save", {
    tiles = {eco_editor.button_base_texture .. "^eco_editor_save.png"},
    groups = { not_in_creative_inventory = 1 },
    light_source = 10,
    on_construct = function(pos)
        local meta = core.get_meta(pos)
        meta:set_string("infotext", "Save")
    end,
    on_punch = function(pos, _, player)
        local meta = core.get_meta(pos)

        local editor_origin_pos = core.string_to_pos(meta:get_string("editor_origin_pos"))
        eco_editor.save(editor_origin_pos, player)
    end
})
