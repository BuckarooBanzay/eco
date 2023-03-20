
-- returns the origin of the placed building
function building_lib.get_origin(mapblock_pos)
	local _, origin = mapblock_lib.resolve_data_link(building_lib.store, mapblock_pos)
	return origin
end

-- returns the building_info on the position
function building_lib.get_placed_building_info(mapblock_pos)
	local mapblock_data, origin = mapblock_lib.resolve_data_link(building_lib.store, mapblock_pos)
	if mapblock_data and mapblock_data.building then
		return mapblock_data.building, origin
	end
end

-- returns the building_def on the position
function building_lib.get_building_def_at(mapblock_pos)
	local info, origin = building_lib.get_placed_building_info(mapblock_pos)
	if not info then
		return false, "no building found"
	end

	local building_def = building_lib.get_building(info.name)
	if not building_def then
		return false, "building_def not found for '" .. info.name .. "'"
	end

	return building_def, origin, info.rotation
end

function building_lib.get_building_size(building_def, rotation)
	local placement = building_lib.get_placement(building_def.placement)
	return placement.get_size(placement, nil, building_def, rotation)
end

function building_lib.get_build_rotation(player)
	local yaw = player:get_look_horizontal()
	local degrees = yaw / math.pi * 180
	local rotation = 0
	if degrees > 45 and degrees < (90+45) then
		-- x-
		rotation = 180
	elseif degrees > (90+45) and degrees < (180+45) then
		-- z-
		rotation = 90
	elseif degrees < 45 or degrees > (360-45) then
		-- z+
		rotation = 270
	end
	return rotation
end

function building_lib.get_pointed_mapblock(player)
    return mapblock_lib.get_pointed_position(player, 2)
end