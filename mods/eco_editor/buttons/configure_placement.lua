
core.register_node("eco_editor:button_configure_placement", {
    tiles = {eco_editor.button_base_texture .. "^eco_editor_configure_placement.png"},
    groups = { not_in_creative_inventory = 1 },
    light_source = 10,
    on_construct = function(pos)
        local meta = core.get_meta(pos)
        meta:set_string("infotext", "Configure placement")
    end,
})
