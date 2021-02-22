
-- mapblock_pos_hash -> { last_call = os.time() }
local active_mapblock_positions = {}

-- TODO: persist

function building_lib.start_timer(mapblock_pos)
	local hash = minetest.hash_node_position(mapblock_pos)
	active_mapblock_positions[hash] = { last_call = 0 }
end

local function worker()
	local now = os.time()
	for hash, ctx in pairs(active_mapblock_positions) do
		local mapblock_pos = minetest.get_position_from_hash(hash)
		local building_def = building_lib.get_building_at_pos(mapblock_pos)
		if building_def and building_def.timer and type(building_def.timer.run) == "function" then
			-- valid item, check last run time
			local time_diff = now - ctx.last_call
			if time_diff > building_def.timer.interval then
				-- timer expired, run
				building_def.timer.run(mapblock_pos, building_def)
				ctx.last_call = now
			end
		else
			-- invalid item, remove
			active_mapblock_positions[hash] = nil
		end
	end
	minetest.after(1, worker)
end

minetest.after(1, worker)
