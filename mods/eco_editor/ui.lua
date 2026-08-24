
-- namespace
local ui = {}
eco_editor.ui = ui

function ui.formspec(w, h)
    return [[
        formspec_version[3]
        size[]] .. w .. [[,]] .. h .. [[]
        no_prepend[]
        bgcolor[;neither;]
        background9[0,0;0,0;eco_editor_button_square_flat.png;true;8]
    ]]
end

function ui.label(x,y,label)
    return "label["..x..","..y..";"..label.."]"
end

function ui.button_exit(x,y,w,h,name,label)
    return "image_button_exit[" ..
        x..","..y..";"..w..","..h..";" ..
        "eco_editor_button_rectangle_depth_border.png;" ..
        name..";"..label..";" ..
        "true;false;" ..
        "eco_editor_button_rectangle_border.png" ..
        "]"
end

function ui.checkbox_on(x,y,name)
    return "image_button_exit[" ..
        x..","..y..";0.6,0.6;" ..
        "eco_editor_check_square_grey_checkmark.png;" ..
        name..";;" ..
        "true;false;" ..
        "]"
end

function ui.checkbox_off(x,y,name)
    return "image_button_exit[" ..
        x..","..y..";0.6,0.6;" ..
        "eco_editor_check_square_grey.png;" ..
        name..";;" ..
        "true;false;" ..
        "]"
end

function ui.list(location,name,x,y,w,h)
    return "list[" ..
        location .. ";" ..
        name .. ";" ..
        x..","..y..";"..w..","..h..
        "]"
end

function ui.listring()
    return "listring[]"
end