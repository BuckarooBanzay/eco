
function building_lib.do_build(mapblock_pos, building_def, callback)
	local success, message = building_lib.can_build(mapblock_pos, building_def)
	if not success then
		return false, message
	end

	-- place into world
	local placement = building_lib.placements[building_def.placement]
	local size = placement.get_size(placement, mapblock_pos, building_def)

	-- write new data
	for x=mapblock_pos.x,mapblock_pos.x+size.x do
		for y=mapblock_pos.y,mapblock_pos.y+size.y do
			for z=mapblock_pos.z,mapblock_pos.z+size.z do
				local offset_mapblock_pos = {x=x, y=y, z=z}

				-- set mapblock data
				local mapblock_data = building_lib.get_mapblock_data(offset_mapblock_pos) or {}
				mapblock_data.building = {
					name = building_def.name,
					origin = mapblock_pos,
					size = size
				}

				building_lib.set_mapblock_data(offset_mapblock_pos, mapblock_data)
			end
		end
	end

	placement.place(placement, mapblock_pos, building_def, callback)

	return true
end
