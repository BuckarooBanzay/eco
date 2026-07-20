
core.register_node("eco_editor:button_toggle_light", {
    tiles = {eco_editor.button_base_texture .. "^eco_editor_toggle_light.png"},
    groups = { not_in_creative_inventory = 1 },
    light_source = 10,
    on_punch = function(_, _, player)
        local ratio = player:get_day_night_ratio()
        if not ratio or ratio > 0 then
            ratio = 0
        else
            ratio = 1
        end
        player:override_day_night_ratio(ratio)
    end
})