
building_lib_interconnect = {}

local MP = minetest.get_modpath("building_lib_interconnect")
dofile(MP .. "/api.lua")
dofile(MP .. "/scan.lua")
dofile(MP .. "/store.lua")
dofile(MP .. "/events.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
    dofile(MP .. "/mtt.lua")
end