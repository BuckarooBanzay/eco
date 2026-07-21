local MP = core.get_modpath(core.get_current_modname())
eco_template.register_template_path(MP .. "/templates")

if core.get_modpath("mtt") and mtt.enabled then
    dofile(MP .. "/init.spec.lua")
end