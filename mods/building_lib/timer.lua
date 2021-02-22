
local filename = minetest.get_worldpath() .. "/eco_active_buildings.json"

-- mapblock_pos_str -> { last_call = os.time() }
local active_mapblock_positions

local function load_data()
	local file = io.open(filename,"r")
	if file then
		local json = file:read("*a")
		return minetest.parse_json(json) or {}
	else
		return {}
	end
end

local function save_data()
	local file = io.open(filename,"w")
	local json = minetest.write_json(active_mapblock_positions)
	if file and file:write(json) and file:close() then
		return
	else
		error("write to '" .. filename .. "' failed!")
	end
end

-- load data
active_mapblock_positions = load_data()

function building_lib.start_timer(mapblock_pos)
	local str = minetest.pos_to_string(mapblock_pos)
	active_mapblock_positions[str] = { last_call = 0 }
end

local function worker()
	local now = os.time()
	for str, ctx in pairs(active_mapblock_positions) do
		local mapblock_pos = minetest.string_to_pos(str)
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
			active_mapblock_positions[str] = nil
		end
	end
	minetest.after(1, worker)
end

minetest.after(1, worker)

-- persist periodically
local function save_worker()
	save_data()
	minetest.after(30, save_worker)
end

minetest.after(5, save_worker)
minetest.register_on_shutdown(save_data)
