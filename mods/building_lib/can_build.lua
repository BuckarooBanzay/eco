
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

local function check_conditions(mapblock_pos, building_def)
	-- go through conditions
	if building_def.conditions then
		-- array-like AND/OR def support
		if building_def.conditions[1] then
			-- OR'ed array
			local placement_allowed = false
			local error_msg

			for _, entry in ipairs(building_def.conditions) do
				local success, msg = check_map("and", entry, mapblock_pos, building_def)
				if success then
					placement_allowed = true
				else
					error_msg = msg
				end
			end

			if not placement_allowed then
				return false, error_msg or "<unknown>"
			end
		else
			-- map
			local success, error_msg = check_map("or", building_def.conditions, mapblock_pos, building_def)
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

	-- check the conditions on the ground-based mapblocks
	local size = placement.get_size(placement, mapblock_pos, building_def)
	for x=mapblock_pos.x, mapblock_pos.x+size.x-1 do
		for z=mapblock_pos.z, mapblock_pos.z+size.z-1 do
			local offset_mapblock_pos = {x=x, y=mapblock_pos.y, z=z}
			local is_free = check_free(offset_mapblock_pos)
			if not is_free then
				return false, "Space occupied at " .. minetest.pos_to_string(offset_mapblock_pos)
			end

			local success, msg = check_conditions(offset_mapblock_pos, building_def)
			if not success then
				return false, msg
			end
		end
	end

	local success, message = placement.check(placement, mapblock_pos, building_def)
	if not success then
		return false, message
	end

	-- all checks ok
	return true
end
