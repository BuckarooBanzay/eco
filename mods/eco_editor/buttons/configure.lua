
core.register_node("eco_editor:button_configure", {
    tiles = {eco_editor.button_base_texture .. "^eco_editor_configure.png"},
    groups = { not_in_creative_inventory = 1 },
    light_source = 10,
    on_construct = function(pos)
        local meta = core.get_meta(pos)
        meta:set_string("infotext", "Configure placement")
    end,
    on_punch = Promise.asyncify(function(await, pos, _, player)
        local meta = core.get_meta(pos)
        local manifest = core.parse_json(meta:get_string("manifest"))
        local placement = eco_api.get_placement(manifest.placement)
        local config = placement.get_configuration(manifest)

        -- apply global config
        local global_config = eco_template.get_common_configuration()
        for k, v in pairs(global_config) do
            config[k] = v
        end

        local categories = {}
        for _, cfg in pairs(config) do
            categories[cfg.category] = true
        end

        print(dump({
            config = config,
            categories = categories
        })) -- XXX

        local fs = eco_editor.ui.formspec(10,11) ..
            eco_editor.ui.label(0.5,0.5,"Configure mapgen params:") ..
            -- TODO: temperature, humidity, min_y, max_y

            eco_editor.ui.button_exit(8,10,1.8,0.8,"exit","Exit")

        local fields = await(Promise.formspec(player:get_player_name(), fs))
        -- TODO: save fields into meta
        print(dump(fields))
    end)
})
