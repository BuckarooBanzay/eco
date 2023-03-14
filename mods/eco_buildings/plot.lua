local MP = minetest.get_modpath("eco_buildings")

local plots = {"1x1", "2x1", "2x2", "3x2", "3x3"}

for _, suffix in ipairs(plots) do
    building_lib.register_building("eco_buildings:plot_" .. suffix, {
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
    })
end