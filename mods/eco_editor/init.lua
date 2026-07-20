local MP = core.get_modpath(core.get_current_modname())
eco_api.register_template_path(MP .. "/templates")

eco_editor = {
    button_base_texture = "eco_steel_block.png",

    -- origin-pos-string -> bool
    operation_active = {}
}

dofile(MP .. "/util.lua")
dofile(MP .. "/setup.lua")
dofile(MP .. "/chatcommands.lua")
dofile(MP .. "/buttons/exit.lua")
dofile(MP .. "/buttons/save.lua")
dofile(MP .. "/buttons/toggle_light.lua")
dofile(MP .. "/buttons/configure_placement.lua")
