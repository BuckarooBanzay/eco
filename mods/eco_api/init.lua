local MP = minetest.get_modpath(minetest.get_current_modname())

eco_api = {
    store = minetest.get_mod_storage()
}

dofile(MP .. "/api.lua")
dofile(MP .. "/cityblock.lua")
dofile(MP .. "/stats.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
    dofile(MP .. "/cityblock.spec.lua")
end