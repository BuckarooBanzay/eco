local formname = "building_lib_placer_configure"

local function get_building_list()
    local building_list = {}
    for name, building_def in pairs(building_lib.get_buildings()) do
        if not building_def.alias then
            -- only add original names, not aliases
            table.insert(building_list, name)
        end
    end
    table.sort(building_list, function(a,b) return a < b end)
    return building_list
end

local function get_formspec(itemstack)
    local meta = itemstack:get_meta()
    local building_list = get_building_list()

    local selected_buildingname = meta:get_string("buildingname")
    if not selected_buildingname or selected_buildingname == "" then
        selected_buildingname = building_list[1]
    end

    local selected_building = 1
    local textlist = ""

    for i, buildingname in ipairs(building_list) do
        if selected_buildingname == buildingname then
            selected_building = i
        end

        textlist = textlist .. buildingname
        if i < #building_list then
            textlist = textlist .. ","
        end
    end

    return "size[8,7;]" ..
        "textlist[0,0.1;8,6;buildingname;" .. textlist .. ";" .. selected_building .. "]" ..
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

    if fields.buildingname then
        local parts = fields.buildingname:split(":")
        if parts[1] == "CHG" then
            local itemstack = player:get_wielded_item()
            local meta = itemstack:get_meta()

            local selected = tonumber(parts[2])
            local building_list = get_building_list()

            local buildingname = building_list[selected]
            if not buildingname then
                return
            end

            meta:set_string("buildingname", buildingname)
            meta:set_string("description", "Selected building: '" .. buildingname .. "'")
            player:set_wielded_item(itemstack)
        end
    end
end)

minetest.register_tool("building_lib:place", {
    description = "building_lib placer",
    inventory_image = "building_lib_place.png^[colorize:#00ff00",
    stack_max = 1,
    range = 0,
    on_secondary_use = function(itemstack, player)
        minetest.show_formspec(player:get_player_name(), formname, get_formspec(itemstack))
    end,
    on_use = function(itemstack, player)
        local playername = player:get_player_name()
        local pointed_mapblock_pos = building_lib.get_pointed_mapblock(player)
        local rotation = building_lib.get_build_rotation(player)

        local placed_building_info, placed_building_origin = building_lib.get_placed_building_info(pointed_mapblock_pos)
        if placed_building_info then
            -- use origin and rotation of existing pointed-at building
            pointed_mapblock_pos = placed_building_origin
            rotation = placed_building_info.rotation
        end

        local meta = itemstack:get_meta()
        local buildingname = meta:get_string("buildingname")
        local success, err = building_lib.build(pointed_mapblock_pos, playername, buildingname, rotation)
        if not success then
            minetest.chat_send_player(playername, err)
        end
    end,
    on_step = function(itemstack, player)
        local playername = player:get_player_name()
        local pointed_mapblock_pos = building_lib.get_pointed_mapblock(player)
        local rotation = building_lib.get_build_rotation(player)

        local placed_building_info, placed_building_origin = building_lib.get_placed_building_info(pointed_mapblock_pos)
        if placed_building_info then
            -- use origin and rotation of existing pointed-at building
            pointed_mapblock_pos = placed_building_origin
            rotation = placed_building_info.rotation
        end

        local meta = itemstack:get_meta()
        local buildingname = meta:get_string("buildingname")
        local building_def = building_lib.get_building(buildingname)
        if not building_def then
            building_lib.clear_preview(playername)
            return
        end

        local size = building_lib.get_building_size(building_def, rotation)
        local mapblock_pos2 = vector.add(pointed_mapblock_pos, vector.subtract(size, 1))

        local color = "#00ff00"
        local can_build = building_lib.can_build(pointed_mapblock_pos, playername, building_def.name, rotation)
        if not can_build then
            color = "#ffff00"
        end

        building_lib.show_preview(
            playername,
            "building_lib_place.png",
            color,
            building_def,
            pointed_mapblock_pos,
            mapblock_pos2,
            rotation
        )
    end,
    on_blur = function(player)
        local playername = player:get_player_name()
        building_lib.clear_preview(playername)
    end
})
