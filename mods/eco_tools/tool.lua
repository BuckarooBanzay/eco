local formname = "eco_placer_configure"

local function get_formspec(itemstack)
    local meta = itemstack:get_meta()
    local selected_category = meta:get_string("category") or "_uncategorized"
    
end

minetest.register_on_player_receive_fields(function(player, f, fields)
    if not minetest.check_player_privs(player, { mapblock_lib = true }) then
        return
    end
    if formname ~= f then
        return
    end
    if fields.quit then
        return
    end

    if fields.buildingname then
        local parts = fields.buildingname:split(":")
        if parts[1] == "CHG" then
            local itemstack = player:get_wielded_item()
            local meta = itemstack:get_meta()
            local selected_category = meta:get_string("category") or "_uncategorized"

            local selected = tonumber(parts[2])
            local building_list = building_lib.get_buildings_by_category(selected_category)

            local building = building_list[selected]
            if not building then
                return
            end

            meta:set_string("buildingname", building.name)
            meta:set_string("description", "Selected building: '" .. building.name .. "'")
            player:set_wielded_item(itemstack)
        end
    elseif fields.category then
        local itemstack = player:get_wielded_item()
        local meta = itemstack:get_meta()
        meta:set_string("category", fields.category)
        player:set_wielded_item(itemstack)
        minetest.show_formspec(player:get_player_name(), formname, get_formspec(itemstack))
    end
end)

minetest.register_tool("eco_tools:placer", {
    description = "eco placement tool",
    inventory_image = "building_lib_place.png^[colorize:#00ff00",
    stack_max = 1,
    range = 0,
    on_secondary_use = function(itemstack, player)
        minetest.show_formspec(player:get_player_name(), formname, get_formspec(itemstack))
    end,
    on_use = function(itemstack, player)
        local playername = player:get_player_name()
        local meta = itemstack:get_meta()
        local buildingname = meta:get_string("buildingname")

        local building_def, mb_pos1, _, rotation = building_lib.get_next_buildable_position(player, buildingname)

        if building_def then
            building_lib.build(mb_pos1, playername, buildingname, rotation)
            :catch(function(err)
                minetest.chat_send_player(playername, err)
            end)
        end
    end,
    on_step = function(itemstack, player)
        local playername = player:get_player_name()
        local meta = itemstack:get_meta()
        local buildingname = meta:get_string("buildingname")

        local building_def, mb_pos1, mb_pos2, rotation = building_lib.get_next_buildable_position(player, buildingname)
        if building_def then
            building_lib.show_display(
                playername,
                "building_lib_place.png",
                "#00ff00",
                building_def,
                mb_pos1,
                mb_pos2,
                rotation
            )
        else
            building_lib.clear_display(playername)
        end
    end,
    on_deselect = function(_, player)
        local playername = player:get_player_name()
        building_lib.clear_display(playername)
    end
})
