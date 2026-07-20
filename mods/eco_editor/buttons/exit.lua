
core.register_node("eco_editor:button_exit", {
    tiles = {eco_editor.button_base_texture .. "^eco_editor_exit.png"},
    groups = { not_in_creative_inventory = 1 },
    light_source = 10,
    on_construct = function(pos)
        local meta = core.get_meta(pos)
        meta:set_string("infotext", "Exit")
    end,
    on_punch = function(pos, _, player)
        local meta = core.get_meta(pos)

        local mapblock_pos1 = core.string_to_pos(meta:get_string("origin_mapblock_pos"))
        local template_size = core.string_to_pos(meta:get_string("template_size"))

        if eco_editor.operation_active[core.pos_to_string(mapblock_pos1)] then
            core.chat_send_player(player:get_player_name(),"Operation still in progress, please await completion first")
            return
        end

        local mapblock_pos2 = vector.add(mapblock_pos1, vector.add(template_size, 1))

        for mapblock_pos in mapblock_lib.pos_iterator(mapblock_pos1, mapblock_pos2) do
            mapblock_lib.clear_mapblock(mapblock_pos)
            player:send_mapblock(mapblock_pos)
        end

        -- reset light override
        player:override_day_night_ratio()
    end
})
