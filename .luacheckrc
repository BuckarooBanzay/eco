globals = {
	"default",
	"player_api",
	"circular_saw",
	"stairsplus"
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

	"creative"
}

files["mods/default"] = {
	unused_args = false,
}

files["mods/player_api/api.lua"] = {
	globals = {
		"minetest"
	}
}
