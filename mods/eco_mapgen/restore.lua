
function eco_mapgen.restore_mapblock(mapblock_pos)
    -- remove data from mapblock
    mapblock_lib.set_mapblock_data(mapblock_pos, nil)

    -- re-render mapblock
    eco_mapgen.render_mapblock(mapblock_pos)
end

minetest.register_chatcommand("mapgen_restore", {
    privs = { server = true },
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "player not found"
		end

		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
		eco_mapgen.restore_mapblock(mapblock_pos)

		return true, "restored mapblock " .. minetest.pos_to_string(mapblock_pos)
	end
})