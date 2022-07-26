
minetest.register_on_generated(function(minp, maxp)
	-- 5x5x5 mapblocks per chunk
	assert((maxp.x - minp.x + 1) == 80)

	local min_mapblock = mapblock_lib.get_mapblock(minp)
	local max_mapblock = mapblock_lib.get_mapblock(maxp)

	for z=min_mapblock.z,max_mapblock.z do
	for x=min_mapblock.x,max_mapblock.x do
	for y=min_mapblock.y,max_mapblock.y do

		local mapblock_pos = { x=x, y=y, z=z }
		eco_mapgen.render_mapblock(mapblock_pos)

	end --y
	end --x
	end --z

end)

minetest.register_chatcommand("mapgen_info", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "player not found"
		end

		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
		local info = eco_mapgen.get_slope_info(mapblock_pos)

		return true, dump(info)
	end
})
