globals = {
	"eco_mapgen"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split", "trim"}},
	table = {fields = {"copy", "getn"}},

	-- Luanti
	"core",
	"vector", "ItemStack",
	"dump", "dump2",
	"VoxelArea", "AreaStore",

	-- mods
	"eco_api", "mapblock_lib", "mtt"
}
