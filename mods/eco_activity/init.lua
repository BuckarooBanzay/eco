
local old_set_mapblock_data = mapblock_lib.set_mapblock_data

-- mapblock_pos_hash -> true
local active_mapblocks = {}

local function get_building_on_step(mapblock_data)
	if mapblock_data and mapblock_data.building then
		local def = minetest.registered_items[mapblock_data.building.name]
		return def and def.eco and def.eco.on_step
	end
end

mapblock_lib.set_mapblock_data = function(mapblock_pos, mapblock_data)
	if get_building_on_step(mapblock_data) then
		local hash = minetest.hash_node_position(mapblock_pos)
		active_mapblocks[hash] = true
	end
	old_set_mapblock_data(mapblock_pos, mapblock_data)
end

local function worker()
	for hash in pairs(active_mapblocks) do
		local mapblock_pos = minetest.get_position_from_hash(hash)
		local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
		local on_step = get_building_on_step(mapblock_data)
		if type(on_step) == "function" then
			-- TODO: proper implementation
			on_step(mapblock_pos)
		end
	end
	minetest.after(1, worker)
end

minetest.after(1, worker)
