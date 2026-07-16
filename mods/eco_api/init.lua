local MP = core.get_modpath(core.get_current_modname())

eco_api = {
    store = core.get_mod_storage()
}

dofile(MP .. "/api.lua")
dofile(MP .. "/template.lua")

if core.get_modpath("mtt") and mtt.enabled then
end