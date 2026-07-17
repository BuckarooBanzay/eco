local MP = core.get_modpath(core.get_current_modname())
eco_api.register_template_path(MP .. "/templates")

eco_editor = {}

dofile(MP .. "/edit.lua")
