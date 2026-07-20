
local placements = {}

function eco_api.register_placement(name, placement)
    assert(placement)
    assert(type(placement.check_size) == "function", "check_size function on '" .. name .. "'")
    assert(type(placement.place) == "function", "place function on '" .. name .. "'")
    placements[name] = placement
end

function eco_api.get_placement(name)
    return assert(placements[name], "placement exists: '" .. name .. "'")
end