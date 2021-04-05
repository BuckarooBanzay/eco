
function building_lib.can_build(mapblock_pos, building_def)
	-- manual can_build function
	if type(building_def.can_build) == "function" then
		local success, message = building_def.can_build(mapblock_pos, building_def)
		if not success then
			return success, message
		end
	end

	-- go through placement flags
	if building_def.conditions then
		-- TODO: array-like AND/OR def support
		local placement_allowed = false
		local error_msg

		for key, value in pairs(building_def.conditions) do
			local condition = building_lib.conditions[key]
			if condition and type(condition.can_build) == "function" then
				local success, msg = condition.can_build(mapblock_pos, building_def, value)
				if not success then
					error_msg = msg
				else
					placement_allowed = true
				end
			end
		end

		if not placement_allowed then
			return false, error_msg or "<unknown>"
		end
	end

	-- check placement definition
	local placement = building_lib.placements[building_def.placement]
	local success, message = placement.check(mapblock_pos, building_def)
	if not success then
		return false, message
	end

	-- all checks ok
	return true
end
