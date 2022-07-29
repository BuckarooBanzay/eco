
function building_lib.do_build(mapblock_pos, building_def, callback)
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

				-- set mapblock data
				building_lib.store:merge(offset_mapblock_pos, {
					building = {
						name = building_def.name,
						origin = mapblock_pos,
						size = size
					}
				})
			end
		end
	end

	placement.place(placement, mapblock_pos, building_def, callback)

	return true
end
