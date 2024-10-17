local formname = "fs-test"

local fs = [[
size[20,10;]
real_coordinates[true]
dropdown[0.5,0.5;9,0.8;category;Streets,Plots;1]

textlist[0.5,1.5;9,8;buildingname;Street straight,Street all sides;2]

image[13,0;4,4;eco_buildings_park_preview.png]

textarea[11,5;10,5;;;stuff
and things]

button_exit[11,8.7;8,0.8;select;Select]
]]

minetest.register_chatcommand("fs", {
    func = function(name)
        minetest.show_formspec(name, formname, fs)
    end
})