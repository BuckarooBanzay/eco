local MP = minetest.get_modpath("eco_transport")

eco_transport = {}

dofile(MP .. "/api.lua")
dofile(MP .. "/common.lua")
dofile(MP .. "/entity.lua")
dofile(MP .. "/transport.lua")
dofile(MP .. "/container.lua")
dofile(MP .. "/conveyors.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
    dofile(MP .. "/common.spec.lua")
end