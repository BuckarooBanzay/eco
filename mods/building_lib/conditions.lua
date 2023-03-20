
-- checks a single condition
local function check_condition(key, value, mapblock_pos)
	local condition = building_lib.get_condition(key)
	if condition and type(condition.can_build) == "function" then
		return condition.can_build(mapblock_pos, value)
	end
	return true
end

-- checks a table of conditions with the given mapblock_pos
-- all entries have to match
function building_lib.check_condition_table(map, mapblock_pos)
	for key, value in pairs(map) do
		local success, msg = check_condition(key, value, mapblock_pos)
		if not success then
			-- failure and in AND mode, return immediately
			return false, msg or "condition failed: '" .. key .. "' pos: " .. minetest.pos_to_string(mapblock_pos)
		end
	end
	return true
end

local default_condition_groups = {
	{["*"] = { empty = true }}
}

-- rotates a condition group by given rotation
-- TODO: only supports sizes of 1
function building_lib.rotate_condition_group(condition_group, rotation)
	if rotation == 0 then
		-- no rotation
		return condition_group
	end

	local new_condition_group = {}
	for selector, condition in pairs(condition_group) do
		local pos = minetest.string_to_pos(selector)
		if pos then
			-- rotate position
			local rotated_pos = mapblock_lib.rotate_pos(pos, {x=0, y=0, z=0}, rotation)
			new_condition_group[minetest.pos_to_string(rotated_pos)] = condition
		else
			-- keep selector name
			new_condition_group[pos] = condition
		end
	end
	return new_condition_group
end

-- go through all condition groups and return true if any of them matches
function building_lib.check_condition_groups(mapblock_pos1, mapblock_pos2, condition_groups)
	local success, err
	for _, condition_group in ipairs(condition_groups or default_condition_groups) do
		success, err = building_lib.check_condition_group(mapblock_pos1, mapblock_pos2, condition_group)
		if success then
			return true
		end
	end
	return false, "no matching condition found" .. (err and ", last error: " .. err or "")
end

function building_lib.check_condition_group(mapblock_pos1, mapblock_pos2, condition_group)
	local group_match = true
	local success, err

	for selector, conditions in pairs(condition_group) do
		local it
		if selector == "*" then
			-- match all
			it = mapblock_lib.pos_iterator(mapblock_pos1, mapblock_pos2)
		elseif selector == "base" then
			-- match only base positions
			it = mapblock_lib.pos_iterator(mapblock_pos1, {x=mapblock_pos2.x, y=mapblock_pos1.y, z=mapblock_pos2.z})
		elseif selector == "underground" or selector == "below" then
			-- match only underground positions
			it = mapblock_lib.pos_iterator({
				x=mapblock_pos1.x, y=mapblock_pos1.y-1, z=mapblock_pos1.z
			},{
				x=mapblock_pos2.x, y=mapblock_pos1.y-1, z=mapblock_pos2.z
			})
		elseif selector == "above" then
			-- match only above positions
			it = mapblock_lib.pos_iterator({
				x=mapblock_pos1.x, y=mapblock_pos1.y+1, z=mapblock_pos1.z
			},{
				x=mapblock_pos2.x, y=mapblock_pos1.y+1, z=mapblock_pos2.z
			})
		else
			-- try to parse a manual position
			local rel_pos = minetest.string_to_pos(selector)
			if rel_pos then
				-- single position
				local abs_pos = vector.add(mapblock_pos1, rel_pos)
				it = mapblock_lib.pos_iterator(abs_pos, abs_pos)
			else
				return false, "unknown selector: " .. selector
			end
		end

		for mapblock_pos in it do
			success, err = building_lib.check_condition_table(conditions, mapblock_pos)
			if not success then
				group_match = false
				break
			end
		end

		if not group_match then
			break
		end
	end

	if group_match then
		return true
	end

	return false, err
end

-- checks if a building with specified group is placed there already
building_lib.register_condition("group", {
    can_build = function(mapblock_pos, value)
		local building_def = building_lib.get_building_def_at(mapblock_pos)
		if building_def and building_def.groups and building_def.groups[value] then
			return true
		end
		return false
	end
})

building_lib.register_condition("name", {
    can_build = function(mapblock_pos, value)
		local building_info = building_lib.get_placed_building_info(mapblock_pos)
		return building_info and building_info.name == value
	end
})

-- checks if the mapblock position is empty
building_lib.register_condition("empty", {
    can_build = function(mapblock_pos)
		local building_info = building_lib.get_placed_building_info(mapblock_pos)
		return building_info == nil
	end
})