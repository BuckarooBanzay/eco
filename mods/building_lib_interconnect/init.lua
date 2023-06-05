
building_lib_interconnect = {}

local MP = minetest.get_modpath("building_lib_interconnect")
dofile(MP .. "/api.lua")
dofile(MP .. "/scan.lua")
dofile(MP .. "/store.lua")
dofile(MP .. "/events.lua")
dofile(MP .. "/util/uuid.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
    dofile(MP .. "/scan.spec.lua")
    dofile(MP .. "/store.spec.lua")
    dofile(MP .. "/util/uuid.spec.lua")
end