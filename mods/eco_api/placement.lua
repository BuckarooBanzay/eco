
local placements = {}

function eco_api.register_placement(name, placement)
    placements[name] = placement
end

function eco_api.get_placement(name)
    return assert(placements[name], "placement exists: '" .. name .. "'")
end