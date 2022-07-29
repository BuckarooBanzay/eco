local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_decoration("grass", {
    catalog = MP .. "/schematics/decorations.zip",
    biome = "grass",
    place_on_groups = "solid",
    select = function()
        return {x=math.random(0,3), y=0, z=0}
    end
})