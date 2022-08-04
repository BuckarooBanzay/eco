
function building_lib.do_build(mapblock_pos, building_name, placement_options, callback)
	local building_def = building_lib.get_building(building_name)
	if not building_def then
		return false, "Building not found: '" .. building_name .. "'"
	end

	local success, message = building_lib.can_build(mapblock_pos, building_def)
	if not success then
		return false, message
	end

	-- place into world
	local placement = building_lib.placements[building_def.placement]
	local size = placement.get_size(placement, mapblock_pos, building_def)

	-- write new data
	for x=mapblock_pos.x,mapblock_pos.x+size.x-1 do
		for y=mapblock_pos.y,mapblock_pos.y+size.y-1 do
			for z=mapblock_pos.z,mapblock_pos.z+size.z-1 do
				local offset_mapblock_pos = {x=x, y=y, z=z}

				if vector.equals(offset_mapblock_pos, mapblock_pos) then
					-- origin
					building_lib.store:merge(offset_mapblock_pos, {
						building = {
							name = building_def.name,
							size = size
						}
					})
				else
					-- reference to origin
					building_lib.store:merge(offset_mapblock_pos, {
						building = {
							ref = mapblock_pos
						}
					})
				end
			end
		end
	end

	placement.place(placement, mapblock_pos, building_def, placement_options, callback)
	building_lib.store:merge(mapblock_pos, {
		placement_options = placement_options
	})

	return true
end
