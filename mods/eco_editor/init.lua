local MP = core.get_modpath(core.get_current_modname())
eco_api.register_template_path(MP .. "/templates")

eco_editor = {
    button_base_texture = "eco_steel_block.png",

    -- origin-pos-string -> bool
    operation_active = {},

    button_offsets = {
        exit = {x=10, y=20, z=0},
        save = {x=12, y=20, z=0},
        toggle_light = {x=14, y=20, z=0},
        configure_placement = {x=16, y=20, z=0},
        configure_rotation = {x=18, y=20, z=0},
        configure_mapgen = {x=20, y=20, z=0}
    }
}

dofile(MP .. "/util.lua")
dofile(MP .. "/ui.lua")
dofile(MP .. "/setup.lua")
dofile(MP .. "/save.lua")
dofile(MP .. "/chatcommands.lua")
dofile(MP .. "/buttons/exit.lua")
dofile(MP .. "/buttons/save.lua")
dofile(MP .. "/buttons/toggle_light.lua")
dofile(MP .. "/buttons/configure_rotation.lua")
dofile(MP .. "/buttons/configure_placement.lua")
dofile(MP .. "/buttons/configure_mapgen.lua")