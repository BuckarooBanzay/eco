globals = {
	"eco_mapgen"
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
	"building_lib", "mapblock_lib", "mtt"
}
