
-- name -> {}
local templates = {}

local function create_template(manifest, zip_filename)
    local template = {
        manifest = manifest,
        zip_filename = zip_filename
    }

    -- place template in-world with selected placement engine
    function template.place(mapblock_pos, options)
        local placement = eco_api.get_placement(manifest.placement)
        return placement.place(template, mapblock_pos, options)
    end

    return template
end

local template_paths = {}

function eco_api.register_template_path(path)
    assert(core.path_exists(path), "template-path exists: '" .. path .. "'")
    table.insert(template_paths, path)
    local count = 0
    local t_start = core.get_us_time()

    -- register all templates in path
    for _, filename in ipairs(core.get_dir_list(path, false)) do
        if string.match(filename, "[%l|%d|_]+[.]zip$") then
            count = count + 1
            local zip_filename = path .. "/" .. filename

            local f = io.open(zip_filename, "rb")
            local z = mtzip.unzip(f)

            local eco_json_file = assert(z:get("eco.json"), "eco.json exists in '" .. zip_filename .. "'")
            local manifest = core.parse_json(eco_json_file)
            assert(manifest, "manifest is readable: '" .. zip_filename .. "'")
            assert(eco_api.get_placement(manifest.placement), "placement exists: '" .. manifest.placement .. "'")

            f:close()

            local prefix = string.sub(filename, 1, #filename - 4) -- ".zip"
            templates[prefix] = create_template(manifest, zip_filename)
        end
    end

    local t_end = core.get_us_time()
    print("[eco] loaded " .. count .. " templates from '" .. path .. "' in " .. (t_end-t_start) .. " us")

    return count
end

function eco_api.reload_template_paths()
    for _, path in ipairs(template_paths) do
        eco_api.register_template_path(path)
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

function eco_api.create_new_template(template_name)
    local manifest = {
        placement = "plain"
    }
    local zip_filename = eco_api.world_template_path .. "/" .. template_name .. ".zip"

    local template = create_template(manifest, zip_filename)
    templates[template_name] = template

    return template
end