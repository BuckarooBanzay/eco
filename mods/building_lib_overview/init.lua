local MP = minetest.get_modpath("building_lib_overview")

building_lib_overview = {}

dofile(MP .. "/common.lua")
dofile(MP .. "/overview.lua")
dofile(MP .. "/switcher.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
	dofile(MP .. "/overview.spec.lua")
end
