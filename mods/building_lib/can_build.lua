
function building_lib.can_build(mapblock_pos, building_def)
	if type(building_def.can_build) == "function" then
		local success, message = building_def.can_build(mapblock_pos, building_def)
		if not success then
			return success, message
		end
	end

	local placement = building_lib.placements[building_def.placement]
	local success, message = placement.check(mapblock_pos, building_def)
	if not success then
		return false, message
	end

	-- all checks ok
	return true
end
