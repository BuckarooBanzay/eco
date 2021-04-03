
function building_lib.get_groups_at_pos(mapblock_pos)
	local building_def = building_lib.get_building_at_pos(mapblock_pos)
	if not building_def then
		return {}
	end

	return building_def.groups or {}
end
