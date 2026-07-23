local Template = {}
local Template_mt = { __index = Template }

-- place template in-world with selected placement engine
function Template:place(mapblock_pos, options)
    local placement = eco_api.get_placement(self.manifest.placement)
    return placement.place(self, mapblock_pos, options)
    -- TODO: store data
end

function Template:remove(mapblock_pos, mapblock_data)
    -- TODO: retrieve data
    local placement = eco_api.get_placement(self.manifest.placement)
    return placement.remove(self, mapblock_pos, mapblock_data)
end

-- validate size and placement
function Template:validate()
    local placement = eco_api.get_placement(self.manifest.placement)
    if not placement.check_size(self.manifest.size) then
        return false, "size check failed to placement: '"..self.manifest.placement.."'"
    end
    return true
end

-- creates a new template instance from the given manifest and zip-filename
function eco_template.create_template(manifest, zip_filename)
    local self = {
		manifest = manifest,
        zip_filename = zip_filename
	}
	return setmetatable(self, Template_mt)
end
