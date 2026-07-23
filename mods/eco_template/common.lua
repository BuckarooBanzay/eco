-- checks if the template name is valid
function eco_template.check_template_name(template_name)
    if string.match(template_name, "^[%w|_]+$") then
        return true
    end
    return false, "Invalid characters in template name, allowed are: digits, letters and underscore"
end

-- creates a new template instance from the given path and filename (zip)
function eco_template.create_template_from_zip(path, filename)
    local template_name = string.sub(filename, 1, #filename - 4) -- ".zip"
    local name_valid, name_err = eco_template.check_template_name(template_name)
    if not name_valid then
        return false, name_err
    end

    local zip_filename = path .. "/" .. filename

    local f = io.open(zip_filename, "rb")
    local z = mtzip.unzip(f)

    local eco_json_file = assert(z:get("eco.json"), "eco.json exists in '" .. zip_filename .. "'")
    local manifest = core.parse_json(eco_json_file)
    assert(manifest, "manifest is readable: '" .. zip_filename .. "'")
    assert(manifest.size, "manifest has size: '" .. zip_filename .. "'")
    assert(eco_api.get_placement(manifest.placement), "placement exists: '"..manifest.placement.."'")

    f:close()

    return eco_template.create_template(manifest, zip_filename)
end

-- creates an empty template with given size and placement
function eco_template.create_new_template(template_name, size, placement_name)
    local name_valid, name_err = eco_template.check_template_name(template_name)
    if not name_valid then
        return false, name_err
    end

    local manifest = {
        placement = placement_name,
        size = size
    }
    local zip_filename = eco_template.world_template_path .. "/" .. template_name .. ".zip"

    local template, err = eco_template.create_template(manifest, zip_filename)
    if err then
        return false, err
    end

    return template
end
