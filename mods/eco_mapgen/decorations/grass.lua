local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen.register_decoration("grass", {
    catalog = MP .. "/schematics/decorations_grass.zip",
    chance = 2,
    select = function()
        return {x=0, y=0, z=math.random(0,3)}
    end
})

eco_mapgen.register_decoration("grass", {
    catalog = MP .. "/schematics/decorations_pine.zip",
    chance = 20,
    select = function()
        return {x=math.random(0,4), y=0, z=0}
    end
})