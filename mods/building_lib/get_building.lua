
function building_lib.get_building(name)
	return building_lib.buildings[name]
end

function building_lib.get_origin(mapblock_pos)
	local mapblock_data = building_lib.store:get(mapblock_pos)
	local origin = mapblock_pos

	if mapblock_data and mapblock_data.building and mapblock_data.building.ref then
		-- resolve link
		origin = mapblock_data.building.ref
	end

	return origin
end

function building_lib.get_building_at_pos(mapblock_pos)
	local origin = building_lib.get_origin(mapblock_pos)
	if not origin then
		return
	end

	local mapblock_data = building_lib.store:get(origin)
	if mapblock_data and mapblock_data.building then
		return building_lib.get_building(mapblock_data.building.name), origin
	end
end

function building_lib.get_building_size_at(mapblock_pos)
	local building, origin = building_lib.get_building_at_pos(mapblock_pos)
	if building then
		local placement = building_lib.placements[building.placement]

		local size = placement.get_size(placement, mapblock_pos, building)
		return size, origin
	end
end

function building_lib.get_placement_options(mapblock_pos)
	local origin = building_lib.get_origin(mapblock_pos)
	if not origin then
		return
	end

	local mapblock_data = building_lib.store:get(origin)
	if mapblock_data and mapblock_data.placement_options then
		return mapblock_data.placement_options, origin
	end
end

function building_lib.get_building_corners_corners_at(mapblock_pos)
	local size, origin = building_lib.get_building_size_at(mapblock_pos)
	if size then
		return mapblock_pos, vector.add(origin, vector.subtract(size, 1))
	end
end