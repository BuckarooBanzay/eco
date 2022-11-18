eco_buildings = {}

local MP = minetest.get_modpath("eco_buildings")

dofile(MP .. "/street.lua")
dofile(MP .. "/park.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
    dofile(MP .. "/mtt.lua")
end