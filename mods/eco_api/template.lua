
-- name -> {}
local templates = {}

local function read_json(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return core.parse_json(content)
end

local function create_template(manifest, zip_file_path)
    local template = {
        manifest = manifest,
        zip_file_path = zip_file_path
    }

    -- place template in-world with selected placement engine
    function template.place(mapblock_pos, options)
        local placement = eco_api.get_placement(manifest.placement)
        return placement.place(template, mapblock_pos, options)
    end

    return template
end

function eco_api.register_template_path(path)
    assert(core.path_exists(path), "template-path exists: '" .. path .. "'")
    -- register all templates in path
    for _, filename in ipairs(core.get_dir_list(path, false)) do
        local index = string.find(filename, "[.]json")
        if index then
            local prefix = string.sub(filename, 1, index-1)
            local zip_file_path = path .. "/" .. prefix .. ".zip"
            local json_file_path = path .. "/" .. prefix .. ".json"

            assert(core.path_exists(zip_file_path), "zip file exists '" .. zip_file_path .. "'")

            local manifest = read_json(json_file_path)
            assert(manifest, "manifest is readable: '" .. json_file_path .. "'")
            assert(eco_api.get_placement(manifest.placement), "placement exists: '" .. manifest.placement .. "'")

            templates[prefix] = create_template(manifest, zip_file_path)
        end
    end
end

-- create and register global template path last (overrides any previously defined template)
core.register_on_mods_loaded(function()
    core.mkdir(eco_api.world_template_path)
    eco_api.register_template_path(eco_api.world_template_path)
end)

function eco_api.get_template(name)
    return templates[name]
end
