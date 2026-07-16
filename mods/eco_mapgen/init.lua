local MP = core.get_modpath(core.get_current_modname())
eco_api.register_building_path(MP .. "/buildings")

if core.get_modpath("mtt") and mtt.enabled then
    dofile(MP .. "/init.spec.lua")
end