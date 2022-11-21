local MP = minetest.get_modpath("eco_buildings")

eco_buildings = {}

dofile(MP .. "/util/streetname.lua")
dofile(MP .. "/conditions.lua")
dofile(MP .. "/street.lua")
dofile(MP .. "/dirt_street.lua")
dofile(MP .. "/park.lua")
dofile(MP .. "/block.lua")
dofile(MP .. "/strut.lua")
dofile(MP .. "/stone_quarry.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
    dofile(MP .. "/mtt.lua")
end