
function building_lib.do_build(mapblock_pos, building_def)
	local success, message = building_lib.can_build(mapblock_pos, building_def)
	if not success then
		return false, message
	end


	-- place into world
	local placement = building_lib.placements[building_def.placement]
	local affected_offsets = placement.place(mapblock_pos, building_def)

	if not affected_offsets then
		-- default to 1 mapblock
		affected_offsets = { {x=0,y=0,z=0} }
	end

	-- write new data
	for _, offset in ipairs(affected_offsets) do
		local offset_mapblock_pos = vector.add(mapblock_pos, offset)

		-- set mapblock data
		local mapblock_data = mapblock_lib.get_mapblock_data(offset_mapblock_pos)
		mapblock_data = mapblock_data or {}
		mapblock_data.building = {
			name = building_def.name
		}

		mapblock_lib.set_mapblock_data(offset_mapblock_pos, mapblock_data)
	end

	-- fire after_place() hooks
	if type(placement.after_place) == "function" then
		placement.after_place(mapblock_pos, building_def)
	end

	-- start timer, if defined
	if building_def.timer then
		building_lib.start_timer(mapblock_pos, building_def)
	end

	return true
end
