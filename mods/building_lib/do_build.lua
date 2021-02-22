
function building_lib.do_build(mapblock_pos, building_def)
	local success, message = building_lib.can_build(mapblock_pos, building_def)
	if not success then
		return false, message
	end

	local placement = building_lib.placements[building_def.placement]
	placement.place(mapblock_pos, building_def)

	return true
end
