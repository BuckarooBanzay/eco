eco_ui = {}

function eco_ui.formspec(width, height, background9)
    return [[
        size[]] .. width .. "," .. height .. [[;]
        real_coordinates[true]
        background9[0,0;]] .. width .. "," .. height .. [[;]] .. background9 .. [[;true;20]
        bgcolor[;true]
    ]]
end

function eco_ui.formspec_primary(width, height)
    return eco_ui.formspec(width, height, "eco_ui_panel_blue.png")
end

function eco_ui.button_exit(x, y, width, height, name, label)
    return string.format(
        "image_button_exit[%s,%s;%s,%s;eco_ui_button_grey.png;%s;%s;true;false;eco_ui_button_grey_pressed.png]",
        x, y, width, height, label, name
    )
end

function eco_ui.button_close(x, y, width, height)
    width = width or 1
    height = height or 1
    return string.format(
        "image_button_exit[%s,%s;%s,%s;eco_ui_cross_brown.png;quit;;true;false;eco_ui_cross_grey.png]",
        x, y, width, height
    )
end