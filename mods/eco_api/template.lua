
-- name -> {}
local templates = {}

function eco_api.register_template(name, template)
    templates[name] = template
end

function eco_api.get_template(name)
    return templates[name]
end
