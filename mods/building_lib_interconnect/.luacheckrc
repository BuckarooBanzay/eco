globals = {
	"building_lib_interconnect"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split", "trim"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"minetest",
	"vector", "ItemStack",
	"dump", "dump2",
	"VoxelArea",

	-- mods
	"building_lib",
	"mapblock_lib",
	"mtt"
}
