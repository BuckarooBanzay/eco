if not minetest.settings:get_bool("enable_integration_test") then
    return
end

local pos1 = vector.new(-30,-30,-30)
local pos2 = vector.new(30,30,30)

local jobs = {}

local MP = minetest.get_modpath(minetest.get_current_modname())
table.insert(jobs, loadfile(MP .. "/tests/mapgen.lua")(pos1, pos2))

local job_index = 1

local function worker()
  local job = jobs[job_index]
  if not job then
    -- exit gracefully
    minetest.request_shutdown("success")
    return
  end

  job(function()
    job_index = job_index + 1
    minetest.after(0, worker)
  end)
end

minetest.log("warning", "[TEST] integration-test enabled!")
minetest.register_on_mods_loaded(function()
  -- defer emerging until stuff is settled
  minetest.after(1, worker)
end)
