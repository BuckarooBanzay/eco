
core.register_node("eco_editor:button_configure_rotation", {
    tiles = {eco_editor.button_base_texture .. "^eco_editor_configure_rotation.png"},
    groups = { not_in_creative_inventory = 1 },
    light_source = 10,
    on_construct = function(pos)
        local meta = core.get_meta(pos)
        meta:set_string("infotext", "Configure rotation")

        local inv = meta:get_inventory()
        inv:set_size("disable_orientation", 24)
    end,
    on_punch = Promise.asyncify(function(await, pos, _, player)
        local fs = eco_editor.ui.formspec(10,11) ..
            eco_editor.ui.label(0.5,0.5,"Disable orientation for the following nodes:") ..
            eco_editor.ui.list(
                "nodemeta:"..pos.x..","..pos.y..","..pos.z,"disable_orientation",
                0.1,1,8,3) ..
            eco_editor.ui.list("current_player", "main",
                0.1,5,8,4) ..
            eco_editor.ui.listring() ..
            eco_editor.ui.button_exit(8,10,1.8,0.8,"exit","Exit")

        local fields = await(Promise.formspec(player:get_player_name(), fs))
        print(dump(fields))
    end)
})
