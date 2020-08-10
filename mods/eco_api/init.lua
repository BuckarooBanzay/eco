local function get_mapblock_bounds(pos)
	local mapblock = vector.floor( vector.divide(pos, 16))
  local min = vector.multiply(mapblock, 16)
  local max = vector.add(min, 15)
	return min, max
end

minetest.register_chatcommand("save_export", {
	func = function(name)
    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()
    local min, max = get_mapblock_bounds(pos)
    minetest.create_schematic(min, max, nil, minetest.get_worldpath() .. "/export.mts")
		return true
  end
})

minetest.register_chatcommand("load_export", {
	func = function(name)
    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()
    local min = get_mapblock_bounds(pos)
    minetest.place_schematic(min, minetest.get_worldpath() .. "/export.mts", 0, {}, true, {})
		return true
  end
})
