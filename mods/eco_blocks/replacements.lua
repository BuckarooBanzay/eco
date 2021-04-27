
-- 10 replacement blocks for schematics
for i=0,9 do
    minetest.register_node("eco_blocks:replacement_" .. i, {
        description = "Replacement block #" .. i,
        tiles = {"ehlphabet_0" .. (i+48) .. ".png"},
        groups = {
            dig_immediate = 2
        }
    })
end

local box_slope = {
    type = "fixed",
    fixed = {
        {-0.5,  -0.5,  -0.5, 0.5, -0.25, 0.5},
        {-0.5, -0.25, -0.25, 0.5,     0, 0.5},
        {-0.5,     0,     0, 0.5,  0.25, 0.5},
        {-0.5,  0.25,  0.25, 0.5,   0.5, 0.5}
    }
}

-- 10 slope replacement blocks for schematics
for i=0,9 do
    minetest.register_node("eco_blocks:replacement_slope_" .. i, {
        description = "Replacement slope block #" .. i,
        tiles = {"ehlphabet_0" .. (i+48) .. ".png"},
        paramtype2 = "facedir",
        drawtype = "mesh",
        mesh = "moreblocks_slope.obj",
        collision_box = box_slope,
        selection_box = box_slope,
        groups = {
        dig_immediate = 2
        }
    })
end