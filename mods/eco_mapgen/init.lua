local MP = minetest.get_modpath("eco_mapgen")

eco_mapgen = {}

dofile(MP .. "/buildings.lua")
dofile(MP .. "/mapgen.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
    dofile(MP .. "/mapgen.spec.lua")
end