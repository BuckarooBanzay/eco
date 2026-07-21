local MP = core.get_modpath(core.get_current_modname())

eco_template = {
    world_template_path = core.get_worldpath() .. "/templates"
}
dofile(MP .. "/template.lua")
dofile(MP .. "/discover.lua")

-- placement types
dofile(MP .. "/placements/plain.lua")
dofile(MP .. "/placements/9slice_v1.lua")

if core.get_modpath("mtt") and mtt.enabled then
    dofile(MP .. "/template.spec.lua")
end