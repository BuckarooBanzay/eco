
-- name -> {}
local templates = {}

function eco_api.create_template(manifest, zip_filename)
    local template = {
        manifest = manifest,
        zip_filename = zip_filename
    }

    -- place template in-world with selected placement engine
    function template.place(mapblock_pos, options)
        local placement = eco_api.get_placement(manifest.placement)
        return placement.place(template, mapblock_pos, options)
    end

    -- validate size and placement
    local placement = eco_api.get_placement(manifest.placement)
    if not placement.check_size(manifest.size) then
        return false, "size check failed to placement: '"..manifest.placement.."'"
    end

    return template
end

function eco_api.create_template_from_zip(path, filename)
    local zip_filename = path .. "/" .. filename

    local f = io.open(zip_filename, "rb")
    local z = mtzip.unzip(f)

    local eco_json_file = assert(z:get("eco.json"), "eco.json exists in '" .. zip_filename .. "'")
    local manifest = core.parse_json(eco_json_file)
    assert(manifest, "manifest is readable: '" .. zip_filename .. "'")
    assert(manifest.size, "manifest has size: '" .. zip_filename .. "'")
    assert(eco_api.get_placement(manifest.placement), "placement exists: '"..manifest.placement.."'")

    f:close()

    return eco_api.create_template(manifest, zip_filename)
end

function eco_api.register_template(template, name)
    -- TODO: validate
    templates[name] = template
end

function eco_api.get_template(name)
    return templates[name]
end

function eco_api.create_new_template(template_name, size)
    local manifest = {
        placement = "plain",
        size = size
    }
    local zip_filename = eco_api.world_template_path .. "/" .. template_name .. ".zip"

    local template, err = eco_api.create_template(manifest, zip_filename)
    if err then
        return false, err
    end

    templates[template_name] = template

    return template
end