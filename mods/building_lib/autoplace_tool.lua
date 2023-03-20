local formname = "building_lib_autoplacer_configure"

local function get_autoplacer_list()
    local autoplacer_list = {}
    for name in pairs(building_lib.get_autoplacers()) do
        table.insert(autoplacer_list, name)
    end
    table.sort(autoplacer_list, function(a,b) return a < b end)
    return autoplacer_list
end

local function get_formspec(itemstack)
    local meta = itemstack:get_meta()
    local autoplacer_list = get_autoplacer_list()

    local selected_autoplacer_name = meta:get_string("autoplacer_name")
    if not selected_autoplacer_name or selected_autoplacer_name == "" then
        selected_autoplacer_name = autoplacer_list[1]
    end

    local selected_autoplacer = 1
    local textlist = ""

    for i, autoplacer_name in ipairs(autoplacer_list) do
        if selected_autoplacer_name == autoplacer_name then
            selected_autoplacer = i
        end

        textlist = textlist .. autoplacer_name
        if i < #autoplacer_list then
            textlist = textlist .. ","
        end
    end

    return "size[8,7;]" ..
        "textlist[0,0.1;8,6;autoplacer_name;" .. textlist .. ";" .. selected_autoplacer .. "]" ..
        "button_exit[0.1,6.5;8,1;back;Back]"
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

    if fields.autoplacer_name then
        local parts = fields.autoplacer_name:split(":")
        if parts[1] == "CHG" then
            local itemstack = player:get_wielded_item()
            local meta = itemstack:get_meta()

            local selected = tonumber(parts[2])
            local autoplacer_list = get_autoplacer_list()

            local autoplacer_name = autoplacer_list[selected]
            if not autoplacer_name then
                return
            end

            meta:set_string("autoplacer_name", autoplacer_name)
            meta:set_string("description", "Selected autoplacer: '" .. autoplacer_name .. "'")
            player:set_wielded_item(itemstack)
        end
    end
end)

minetest.register_tool("building_lib:autoplace", {
    description = "building_lib autoplacer",
    inventory_image = "building_lib_autoplace.png^[colorize:#00ff00",
    stack_max = 1,
    range = 0,
    on_secondary_use = function(itemstack, player)
        minetest.show_formspec(player:get_player_name(), formname, get_formspec(itemstack))
    end,
    on_use = function(itemstack, player)
        local meta = itemstack:get_meta()
        local playername = player:get_player_name()
        local autoplacer_name = meta:get_string("autoplacer_name")
        local pointed_mapblock_pos = building_lib.get_pointed_mapblock(player)
        local success, err = building_lib.autoplace(pointed_mapblock_pos, playername, autoplacer_name, true)
        if not success then
            minetest.chat_send_player(playername, err)
        end
    end,
    on_step = function(itemstack, player)
        local playername = player:get_player_name()
        local mapblock_pos1 = building_lib.get_pointed_mapblock(player)
        local meta = itemstack:get_meta()
        local autoplacer_name = meta:get_string("autoplacer_name")

        local success, building_name, rotation = building_lib.can_autoplace(mapblock_pos1, playername, autoplacer_name)
        if not success then
            building_lib.clear_preview(playername)
            return
        end

        local building_def = building_lib.get_building(building_name)
        if not building_def then
            building_lib.clear_preview(playername)
            return
        end

        local size = building_lib.get_building_size(building_def, rotation)
        local mapblock_pos2 = vector.add(mapblock_pos1, vector.subtract(size, 1))

        local color = "#00ff00"
        local can_build = building_lib.can_build(mapblock_pos1, playername, building_def.name, rotation)
        if not can_build then
            color = "#ffff00"
        end

        building_lib.show_preview(
            playername,
            "building_lib_autoplace.png",
            color,
            building_def,
            mapblock_pos1,
            mapblock_pos2,
            rotation
        )
    end,
    on_blur = function(player)
        local playername = player:get_player_name()
        building_lib.clear_preview(playername)
    end
})
