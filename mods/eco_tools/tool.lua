local formname = "eco_placer_configure"

local function get_tool_data(meta)
    -- categories
    local categories = eco_api.get_category_list()
    local category_index = 1
    local category = meta:get_string("category")
    if category == "" then
        -- default to first category
        category = categories[1]
    else
        -- find out index
        for i, c in ipairs(categories) do
            if c == category then
                category_index = i
            end
        end
    end

    -- buildings
    local building_list = eco_api.get_buildings_in_category(category)
    local buildingname_index = 1
    local buildingname = meta:get_string("buildingname")
    if buildingname == "" then
        -- default to first building in category
        buildingname = building_list[1].name
    else
        -- find out index
        for i, def in ipairs(building_list) do
            if def.name == buildingname then
                buildingname_index = i
            end
        end
    end

    return {
        category = category,
        category_index = category_index,
        buildingname = buildingname,
        buildingname_index = buildingname_index
    }
end

local function get_formspec(itemstack)
    local meta = itemstack:get_meta()
    local data = get_tool_data(meta)

    -- categories
    local categories = eco_api.get_categories()
    local category_list = {}
    for _, c in pairs(categories) do
        table.insert(category_list, c.description)
    end
    local category_str = table.concat(category_list, ",")

    -- buildings
    local building_list = eco_api.get_buildings_in_category(data.category)
    local buildingname_list = {}
    for _, building_def in ipairs(building_list) do
        table.insert(buildingname_list, building_def.description or building_def.name)
    end
    local building_str = table.concat(buildingname_list, ",")

    -- get building preview
    local preview = building_lib.get_building_preview(data.buildingname)
    local width = 8
    local height = 4
    local ratio = math.min(width/preview.width, height/preview.height)
    height = preview.height * ratio
    width = preview.width * ratio
    local img_offset_x = (8 - width) / 2

    return eco_ui.formspec_primary(20, 10) .. [[
        dropdown[0.5,0.5;9,0.8;category;]] .. category_str .. [[;]] .. data.category_index .. [[]

        textlist[0.5,1.5;9,8;buildingname;]] .. building_str .. [[;]] .. data.buildingname_index .. [[]

        image[]] .. (11 + img_offset_x) .. [[,1;]] .. width .. "," .. height .. [[;[png:]] .. preview.png .. [[]

        textarea[11,6;10,5;;;stuff
        and things]
    ]] .. eco_ui.button_close(19, 0.1, 0.9, 0.9)
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

    local itemstack = player:get_wielded_item()
    if itemstack:get_name() ~= "eco_tools:placer" then
        return
    end

    local meta = itemstack:get_meta()
    local data = get_tool_data(meta)

    if fields.buildingname then
        local parts = fields.buildingname:split(":")
        if parts[1] == "CHG" then

            local selected = tonumber(parts[2])
            local building_list = eco_api.get_buildings_in_category(data.category)

            local building = building_list[selected]
            if not building then
                return
            end

            meta:set_string("buildingname", building.name)
            meta:set_string("description", "Selected building: '" .. (building.description or building.name) .. "'")
            player:set_wielded_item(itemstack)
            minetest.show_formspec(player:get_player_name(), formname, get_formspec(itemstack))
        end
    elseif fields.category then
        local categories = eco_api.get_categories()
        local category
        for name, cat_def in pairs(categories) do
            -- map from description to technical name
            if not category or cat_def.description == fields.category then
                category = name
            end
        end
        local building_list = eco_api.get_buildings_in_category(category)

        meta:set_string("category", category)
        meta:set_string("buildingname", building_list[1].name)
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
