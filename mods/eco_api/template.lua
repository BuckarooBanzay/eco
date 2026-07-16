
-- name -> {}
local templates = {}

local function read_json(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return core.parse_json(content)
end

function eco_api.register_template_path(path)
    assert(core.path_exists(path), "template-path exists: '" .. path .. "'")
    -- register all templates in path
    for _, filename in ipairs(core.get_dir_list(path, false)) do
        print(filename)
        local index = string.find(filename, "[.]json")
        if index then
            local prefix = string.sub(filename, 1, index-1)
            local zip_file_path = path .. "/" .. prefix .. ".zip"
            assert(core.path_exists(zip_file_path), "zip file exists '" .. zip_file_path .. "'")

            templates[prefix] = {
                manifest = read_json(path .. "/" .. prefix .. ".json"),
                zip_file_path = zip_file_path
            }
        end
    end
end

-- create and register global template path last (overrides any previously defined template)
core.register_on_mods_loaded(function()
    local world_template_path = core.get_worldpath() .. "/templates"
    core.mkdir(world_template_path)
    eco_api.register_template_path(world_template_path)
end)

function eco_api.get_template(name)
    return templates[name]
end

function eco_api.save_template(name, template)
    -- TODO: save to global template path
    -- TODO: replace current definition with newly saved
end