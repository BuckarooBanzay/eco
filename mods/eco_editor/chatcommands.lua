
Promise.register_chatcommand("eco_edit", {
    params = "<template-name>",
    description = "Edit a template",
    func = function(name, params)
        local template = eco_api.get_template(params)
        if not template then
            return true, "Template '" .. params .. "' not found"
        end

        return eco_editor.setup(name, params, template)
    end
})

local function split(inputstr)
  local t = {}
  for str in string.gmatch(inputstr, "([^%s]+)") do
    table.insert(t, str)
  end
  return t
end

core.register_chatcommand("eco_placements", {
    description = "Lists all placement types",
    func = function(playername)
        core.chat_send_player(playername, "Supported placement types:")
        for name, placement in pairs(eco_api.get_placements()) do
            core.chat_send_player(
                playername,
                "* [" .. core.colorize("#00ffffff", name) .. "] " ..
                placement.description
            )
        end
    end
})

Promise.register_chatcommand("eco_create", {
    params = "<template-name> <placement-type> <x-size> <y-size> <z-size>",
    description = "Create a template",
    func = function(name, params)
        local parts = split(params)
        if #parts ~= 5 then
            return true, "Invalid parameter count"
        end

        local template_name = parts[1]
        local placement_name = parts[2]
        local size = {
            x = tonumber(parts[3]),
            y = tonumber(parts[4]),
            z = tonumber(parts[5])
        }

        if not eco_api.get_placement(placement_name) then
            return true, "Placement not found: '"..placement_name.."' use /eco_placements to list all possibilities"
        end

        for _, axis in ipairs({"x","y","z"}) do
            local v = size[axis]
            if not v then
                return true, "Axis '"..axis.."' is not defined"
            end
            if v < 1 then
                return true, "Axis '"..axis.."' should be greater or equal 1"
            end
            if v > 20 then
                return true, "Axis '"..axis.."' should be less than 20"
            end
        end

        local template, err = eco_api.create_new_template(template_name, size, placement_name)
        if err then
            return true, "Create error: " .. err
        end

        -- start editor
        return eco_editor.setup(name, template_name, template)
    end
})


-- TODO: /eco_remove <template-name>
