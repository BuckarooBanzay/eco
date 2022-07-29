

local POS_SLOPE_LOWER = {x=0,y=0,z=0} -- x- on the upper side
local POS_SLOPE_UPPER = {x=0,y=1,z=0} -- x- on the upper side
local POS_ALL_SIDES = {x=1,y=0,z=0}
local POS_STRAIGHT = {x=2,y=0,z=0} -- x+ to x-
local POS_THREE_SIDES = {x=3,y=0,z=0} -- x+/x-/z+
local POS_CORNER = {x=4,y=0,z=0} -- x- to z+
local POS_END = {x=5,y=0,z=0} -- only x- connection

local neighbors = {
	{ x=1, y=0, z=0 },
	{ x=0, y=0, z=1 },
	{ x=0, y=0, z=-1 },
	{ x=-1, y=0, z=0 }
}

local function is_connecting(mapblock_pos, connects_to_groups)
	local groups = building_lib.get_groups(mapblock_pos)
	for group in pairs(groups) do
		if connects_to_groups[group] then
			return true
		end
	end
end

local function get_tile_pos_rotation(mapblock_pos, connects_to_groups)
	local xp = is_connecting(vector.add(mapblock_pos, {x=1,y=0,z=0}), connects_to_groups)
	local xn = is_connecting(vector.add(mapblock_pos, {x=-1,y=0,z=0}), connects_to_groups)
	local zp = is_connecting(vector.add(mapblock_pos, {x=0,y=0,z=1}), connects_to_groups)
	local zn = is_connecting(vector.add(mapblock_pos, {x=0,y=0,z=-1}), connects_to_groups)

	if xp and xn and zp and zn then
		return POS_ALL_SIDES, 0
	-- 3 sided
	elseif xp and xn and zp then
		return POS_THREE_SIDES, 0
	elseif zp and zn and xp then
		return POS_THREE_SIDES, 90
	elseif xp and xn and zn then
		return POS_THREE_SIDES, 180
	elseif zp and zn and xn then
		return POS_THREE_SIDES, 270
	-- straight
	elseif xp and xn then
		return POS_STRAIGHT, 0
	elseif zp and zn then
		return POS_STRAIGHT, 90
	-- corner
	elseif xn and zp then
		return POS_CORNER, 0
	elseif xp and zp then
		return POS_CORNER, 90
	elseif xp and zn then
		return POS_CORNER, 180
	elseif xn and zn then
		return POS_CORNER, 270
	-- end
	elseif xn then
		return POS_END, 0
	elseif zp then
		return POS_END, 90
	elseif xp then
		return POS_END, 180
	elseif zn then
		return POS_END, 270
	end
end

local function place_and_rotate(mapblock_pos, building_def)
	local tile_pos, rotation = get_tile_pos_rotation(mapblock_pos, building_def.connects_to_groups)
	local catalog = mapblock_lib.get_catalog(building_def.catalog)
	if tile_pos then
		-- matching street
		catalog:deserialize(tile_pos, mapblock_pos, {
			transform = {
				rotate = {
					angle = rotation,
					axis = "y"
				}
			}
		})
	else
		-- default 4-way street
		catalog:deserialize(POS_ALL_SIDES, mapblock_pos)
	end
end

local function place_and_rotate_slope(mapblock_pos, building_def, rotation)
	local options = {
		transform = {
			rotate = {
				angle = rotation,
				axis = "y"
			}
		}
	}
	local catalog = mapblock_lib.get_catalog(building_def.catalog)
	catalog:deserialize(POS_SLOPE_LOWER, mapblock_pos, options)
	catalog:deserialize(POS_SLOPE_UPPER, vector.add(mapblock_pos, {x=0,y=1,z=0}), options)
end

local slope_update_directions = {
	[0] = { {x=0,y=0,z=-1}, {x=0,y=1,z=1} },
	[90] = { {x=-1,y=0,z=0}, {x=1,y=1,z=0} },
	[180] = { {x=0,y=0,z=1}, {x=0,y=1,z=-1} },
	[270] = { {x=1,y=0,z=0}, {x=-1,y=1,z=0} }
}

building_lib.register_placement("connected", {
	check = function()
		return true
	end,
	get_size = function(_, mapblock_pos)
		local info = eco_mapgen.get_info(mapblock_pos)
		if info.slope then
			return { x=1, y=2, z=1 }
		else
			return { x=1, y=1, z=1 }
		end
	end,
	place = function(self, mapblock_pos, building_def, callback)
		local info = eco_mapgen.get_info(mapblock_pos)
		local neighbor_updates

		if info.slope then
			-- place a slope
			place_and_rotate_slope(mapblock_pos, building_def, info.rotation)
			neighbor_updates = slope_update_directions[info.rotation]
		else
			-- place a flat tile
			place_and_rotate(mapblock_pos, building_def)
			neighbor_updates = neighbors
		end

		for _, dir in ipairs(neighbor_updates) do
			local neighbor_pos = vector.add(mapblock_pos, dir)
			local neighbor_below_pos = vector.add(neighbor_pos, {x=0,y=-1,z=0})

			local neighbor_info = eco_mapgen.get_info(neighbor_pos)
			local neighbor_below_info = eco_mapgen.get_info(neighbor_below_pos)

			local do_update = true

			local neighbor_below_building_def = building_lib.get_building_at_pos(neighbor_below_pos)
			local neighbor_building_def = building_lib.get_building_at_pos(neighbor_pos)

			if neighbor_below_info.slope and neighbor_below_building_def and
				neighbor_below_building_def.name == building_def.name then
				-- upper part of a built slope, don't update
				do_update = false
			end

			if neighbor_info.slope and not neighbor_below_info.slope then
				-- lower part of a slope, don't update
				do_update = false
			end

			if do_update then
				-- re-place the neighboring mapblock too if it is of the same type
				if neighbor_building_def and neighbor_building_def.placement == self.name then
					place_and_rotate(neighbor_pos, neighbor_building_def)
				end
			end
		end

		callback()
	end
})
