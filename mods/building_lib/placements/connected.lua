
local function is_connecting(mapblock_pos, group, direction)
	local inverse_direction = vector.multiply(direction, -1)
	local neighbor_mapblock = vector.add(mapblock_pos, direction)
	local neighbor_building_def = building_lib.get_building_at_pos(neighbor_mapblock)
	if not neighbor_building_def or not neighbor_building_def.connections then
		return false
	end

	local neighbor_directions = neighbor_building_def.connections[group]
	if not neighbor_directions then
		return false
	end

	for _, neighbor_direction in ipairs(neighbor_directions) do
		if vector.equals(inverse_direction, neighbor_direction) then
			return true
		end
	end

	return false
end

local POS_STRAIGHT = {x=0,y=0,z=0}
local POS_ALL_SIDES = {x=1,y=0,z=0}
local POS_THREE_SIDES = {x=1,y=0,z=1}
local POS_CORNER = {x=0,y=0,z=1}
--local POS_SLOPE_LOWER = {x=0,y=0,z=2}
--local POS_SLOPE_UPPER = {x=0,y=1,z=2}

local function place_street(mapblock_pos, building_def)
	-- check connections on flat surface
	local xplus = is_connecting(mapblock_pos, "street", {x=1, y=0, z=0})
	local xminus = is_connecting(mapblock_pos, "street", {x=-1, y=0, z=0})
	local zplus = is_connecting(mapblock_pos, "street", {x=0, y=0, z=1})
	local zminus = is_connecting(mapblock_pos, "street", {x=0, y=0, z=-1})

	local catalog_pos = POS_STRAIGHT

	local options = {}
	options.transform = options.transform or {}
	options.transform.rotate = options.transform.rotate or {}
	options.transform.rotate.axis = "y"
	options.transform.rotate.angle = 0

	if xplus and xminus and zplus and zminus then
		-- all sides
		catalog_pos = POS_ALL_SIDES

	elseif not xplus and xminus and zplus and zminus then
		-- three sides 90°
		catalog_pos = POS_THREE_SIDES
		options.transform.rotate.angle = 90

	elseif xplus and not xminus and zplus and zminus then
		-- three sides 270°
		catalog_pos = POS_THREE_SIDES
		options.transform.rotate.angle = 270

	elseif xplus and xminus and not zplus and zminus then
		-- three sides 0°
		catalog_pos = POS_THREE_SIDES
		options.transform.rotate.angle = 0

	elseif xplus and xminus and zplus and not zminus then
		-- three sides 180°
		catalog_pos = POS_THREE_SIDES
		options.transform.rotate.angle = 180

	elseif xplus and not xminus and zplus and not zminus then
		-- corner 0°
		catalog_pos = POS_CORNER
		options.transform.rotate.angle = 0

	elseif not xplus and xminus and zplus and not zminus then
		-- corner 270°
		catalog_pos = POS_CORNER
		options.transform.rotate.angle = 270

	elseif xplus and not xminus and not zplus and zminus then
		-- corner 90°
		catalog_pos = POS_CORNER
		options.transform.rotate.angle = 90

	elseif not xplus and xminus and not zplus and zminus then
		-- corner 180°
		catalog_pos = POS_CORNER
		options.transform.rotate.angle = 180

	elseif xplus or xminus then
		-- straight 0°
		catalog_pos = POS_STRAIGHT
		options.transform.rotate.angle = 0

	elseif zplus or zminus then
		-- straight 90°
		catalog_pos = POS_STRAIGHT
		options.transform.rotate.angle = 90

	end

	local catalog = mapblock_lib.get_catalog(building_def.catalog)
	catalog:deserialize(catalog_pos, mapblock_pos, options)
end

local street_neighbor_updates = {
	{ x=1, y=0, z=0 },
	{ x=0, y=0, z=1 },
	{ x=0, y=0, z=-1 },
	{ x=-1, y=0, z=0 },
	{ x=1, y=-1, z=0 },
	{ x=0, y=-1, z=1 },
	{ x=0, y=-1, z=-1 },
	{ x=-1, y=-1, z=0 }
}

function building_lib.update_connections(mapblock_pos)
	local building_def = building_lib.get_building_at_pos(mapblock_pos)

	-- iterate through possible connections
	for _, direction in ipairs(street_neighbor_updates) do
		for group in pairs(building_def.connections) do
			if is_connecting(mapblock_pos, group, direction) then
				local neighbor_mapblock = vector.add(mapblock_pos, direction)
				local other_building_def = building_lib.get_building_at_pos(neighbor_mapblock)
				if other_building_def.placement == "connected" then
					place_street(neighbor_mapblock, other_building_def)
				end
			end
		end

	end
end

building_lib.register_placement({
	name = "connected",
	check = function(_, mapblock_pos)
		if building_lib.get_building_at_pos(mapblock_pos) then
			return false, "already occupied"
		end
		return true
	end,
	get_size = function()
		return { x=1, y=1, z=1 }
	end,
	place = function(_, mapblock_pos, building_def, options)
		place_street(mapblock_pos, building_def, options)
		building_lib.update_connections(mapblock_pos)
	end
})
