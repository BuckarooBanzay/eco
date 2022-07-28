
function building_lib.get_size(mapblock_pos, building_def)
    local placement = building_lib.placements[building_def.placement]
	return placement.get_size(placement, mapblock_pos, building_def)
end

function building_lib.get_corners(mapblock_pos, building_def)
    local size = building_lib.get_size(mapblock_pos, building_def)
    return mapblock_pos, vector.add(mapblock_pos, vector.subtract(size, 1))
end