
function building_lib.do_build(mapblock_pos, building_def)
	local success, message = building_lib.can_build(mapblock_pos, building_def)
	if not success then
		return false, message
	end

	-- set mapblock data
	local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
	mapblock_data = mapblock_data or {}
	mapblock_data.building = {
		name = building_def.name
	}
	mapblock_lib.set_mapblock_data(mapblock_pos, mapblock_data)

	-- place into world
	local placement = building_lib.placements[building_def.placement]
	placement.place(mapblock_pos, building_def)

	-- start timer, if defined
	if building_def.timer then
		building_lib.start_timer(mapblock_pos, building_def)
	end

	return true
end
