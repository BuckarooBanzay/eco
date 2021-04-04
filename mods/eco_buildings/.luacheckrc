globals = {
	"eco_buildings"
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
	"mapblock_lib",
	"building_lib",
	"eco_mapgen"
}
