local formname = "fs-test"

local function get_fs()
    local preview = building_lib.get_building_preview("eco_buildings:stone_quarry")
    local width = 8
    local height = 4

    local ratio = math.min(width/preview.width, height/preview.height)
    height = preview.height * ratio
    width = preview.width * ratio
    local img_offset_x = (8 - width) / 2

    return [[
        size[20,10;]
        real_coordinates[true]
        background9[0,0;20,10;panel_blue.png;true;20]
        bgcolor[;true]

        dropdown[0.5,0.5;9,0.8;category;Streets,Plots;1]

        textlist[0.5,1.5;9,8;buildingname;Street straight,Street all sides;2]

        image[]] .. (11 + img_offset_x) .. [[,0;]] .. width .. "," .. height .. [[;[png:]] .. preview.png .. [[]

        textarea[11,5;10,5;;;stuff
        and things]

        image_button[11,8.7;8,1;buttonLong_grey.png;select;Select;true;false;buttonLong_grey_pressed.png]
    ]]
end

minetest.register_chatcommand("fs", {
    func = function(name)
        minetest.show_formspec(name, formname, get_fs())
    end
})