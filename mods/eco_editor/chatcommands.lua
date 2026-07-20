
core.register_chatcommand("eco_edit", {
    params = "<template-name>",
    description = "Edit a template",
    func = function(name, params)
        local template = eco_api.get_template(params)
        if not template then
            return true, "Template '" .. params .. "' not found"
        end

        eco_editor.setup(name, params)
    end
})

local function split(inputstr)
  local t = {}
  for str in string.gmatch(inputstr, "([^%s]+)") do
    table.insert(t, str)
  end
  return t
end


core.register_chatcommand("eco_create", {
    params = "<template-name> <x-size> <y-size> <z-size>",
    description = "Create a template",
    func = function(name, params)
        local parts = split(params)
        if #parts ~= 4 then
            return true, "Invalid parameter count"
        end

        local template_name = parts[1]
        local size = {
            x = tonumber(parts[2]),
            y = tonumber(parts[3]),
            z = tonumber(parts[4])
        }

        -- TODO: sanitize inputs
        local template = eco_api.create_new_template(template_name)

        -- create stub zipfile
        mapblock_lib.create_empty_catalog(template.zip_filename, size)

        -- start editor
        eco_editor.setup(name, template_name)
    end
})


-- TODO: /eco_remove <template-name>
