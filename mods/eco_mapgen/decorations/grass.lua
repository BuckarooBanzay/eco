local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_decoration("grass", {
    catalog = MP .. "/schematics/decorations_grass.zip",
    min_y = 1,
    max_y = 5,
    chance = 10,
    select = function()
        return {x=math.random(0,3), y=0, z=0}
    end
})

eco_mapgen.register_decoration("grass", {
    catalog = MP .. "/schematics/decorations_pine.zip",
    min_y = 1,
    max_y = 5,
    chance = 20,
    select = function()
        return {x=math.random(0,4), y=0, z=0}
    end
})