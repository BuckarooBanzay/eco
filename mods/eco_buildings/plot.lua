local MP = minetest.get_modpath("eco_buildings")

local plots = {
    ["1x1"] = {
        markers = {
            {
                texture = "building_lib_arrow.png",
                position = {x=1.5, y=0.2, z=0.5},
                rotation = {x=math.pi/2, y=0, z=math.pi/2},
                size = {x=10, y=10}
            }
        }
    },
    ["2x1"] = {},
    ["2x2"] = {},
    ["3x2"] = {},
    ["3x3"] = {}
}

for suffix, overrides in pairs(plots) do
    local def = {
        catalog = MP .. "/schematics/plot_" .. suffix .. ".zip",
        conditions = {
            {
                -- flat surface
                ["*"] = { empty = true },
                ["underground"] = { group = "flat_surface"}
            }
        },
        groups = {
            plot = true,
            ["plot_" .. suffix] = true
        },
        overview = "eco:slab_stone_2"
    }

    for k, v in pairs(overrides) do
        def[k] = v
    end

    building_lib.register_building("eco_buildings:plot_" .. suffix, def)
end