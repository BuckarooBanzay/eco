
local function check_condition(key, value, mapblock_pos, building_def)
	local condition = building_lib.conditions[key]
	if condition and type(condition.can_build) == "function" then
		return condition.can_build(mapblock_pos, building_def, value)
	end
	return true
end

local function check_map(mode, map, mapblock_pos, building_def)
	local placement_allowed = false
	local error_msg

	for key, value in pairs(map) do
		local success, msg = check_condition(key, value, mapblock_pos, building_def)
		if success then
			-- success
			placement_allowed = true
		elseif mode == "and" then
			-- failure and in AND mode, return immediately
			return false, msg
		else
			error_msg = msg
		end
	end

	return placement_allowed, error_msg
end

function building_lib.check_conditions(mapblock_pos, conditions, building_def)
	-- go through conditions
	if conditions then
		-- array-like AND/OR def support
		if conditions[1] then
			-- OR'ed array
			local placement_allowed = false
			local error_msg

			for _, entry in ipairs(conditions) do
				local success, msg = check_map("and", entry, mapblock_pos, building_def)
				if success then
					placement_allowed = true
					break
				else
					error_msg = msg
				end
			end

			if not placement_allowed then
				return false, error_msg or "<unknown>"
			end
		else
			-- map
			local success, error_msg = check_map("or", conditions, mapblock_pos, building_def)
			if not success then
				return false, error_msg or "<unknown>"
			end
		end
	end

	return true
end

local function check_free(mapblock_pos)
	if building_lib.get_building_at_pos(mapblock_pos) then
		return false
	else
		return true
	end
end

function building_lib.can_build(mapblock_pos, building_def)
	-- check placement definition
	local placement = building_lib.placements[building_def.placement]

	local success, message = placement.check(placement, mapblock_pos, building_def)
	if not success then
		return false, message
	end

	-- check the conditions on every mapblock the building would occupy
	local size
	size, message = placement.get_size(placement, mapblock_pos, building_def)
	if not size then
		return false, message
	end

	for x=mapblock_pos.x, mapblock_pos.x+size.x-1 do
		for z=mapblock_pos.z, mapblock_pos.z+size.z-1 do
			for y=mapblock_pos.y, mapblock_pos.y+size.y-1 do
				local offset_mapblock_pos = {x=x, y=y, z=z}
				local is_free = check_free(offset_mapblock_pos)
				if not is_free then
					return false, "Space already occupied at " .. minetest.pos_to_string(offset_mapblock_pos)
				end

				if y == mapblock_pos.y then
					-- check ground conditions
					success, message = building_lib.check_conditions(offset_mapblock_pos, building_def.ground_conditions, building_def)
					if not success then
						return false, message
					end
				end

				success, message = building_lib.check_conditions(offset_mapblock_pos, building_def.conditions, building_def)
				if not success then
					return false, message
				end
			end
		end
	end

	-- all checks ok
	return true
end
