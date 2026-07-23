
-- creates a new template instance from the given manifest and zip-filename
function eco_template.create_template(manifest, zip_filename)
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
