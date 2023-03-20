
minetest.register_tool("building_lib:remove", {
    description = "building_lib remover",
    inventory_image = "building_lib_remove.png^[colorize:#ff0000",
    stack_max = 1,
    range = 0,
    on_use = function(_, player)
        local mapblock_pos = building_lib.get_pointed_mapblock(player)
        local success, err = building_lib.remove(mapblock_pos)
        if not success then
            minetest.chat_send_player(player:get_player_name(), err)
        end
    end,
    on_step = function(_, player)
        local playername = player:get_player_name()
        local pointed_mapblock_pos = building_lib.get_pointed_mapblock(player)

        local building_info, origin = building_lib.get_placed_building_info(pointed_mapblock_pos)
        if not building_info then
            building_lib.clear_preview(playername)
            return
        end

        local building_def = building_lib.get_building(building_info.name)

        local size = building_lib.get_building_size(building_def, building_info.rotation or 0)
        local mapblock_pos2 = vector.add(origin, vector.subtract(size, 1))

        local color = "#ff0000"
        local can_remove = building_lib.can_remove(origin)
        if not can_remove then
            color = "#ffff00"
        end

        building_lib.show_preview(
            playername,
            "building_lib_remove.png",
            color,
            building_def,
            origin,
            mapblock_pos2,
            building_info.rotation
        )
    end,
    on_blur = function(player)
        local playername = player:get_player_name()
        building_lib.clear_preview(playername)
    end
})

