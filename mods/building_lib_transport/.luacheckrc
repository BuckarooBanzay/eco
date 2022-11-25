globals = {
	"building_lib_transport"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split", "trim"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump", "dump2",
	"VoxelArea",
	"minetest",

	-- mods
	"mapblock_lib", "mtt", "building_lib"
}
