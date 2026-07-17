local MP = core.get_modpath(core.get_current_modname())

eco_api = {
    world_template_path = core.get_worldpath() .. "/templates"
}

-- placement types
dofile(MP .. "/placement.lua")
dofile(MP .. "/placements/plain.lua")
dofile(MP .. "/placements/mapgen_v1.lua")
dofile(MP .. "/placements/9slice_v1.lua")

-- template api
dofile(MP .. "/template.lua")
