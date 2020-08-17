minetest.register_chatcommand("grid_info", {
	func = function(name)
    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()
    local mapblock = eco_util.get_mapblock(pos)
    local info = eco_grid.get_mapblock(mapblock)
    local txt

    if info then
      txt = "grid: " .. minetest.pos_to_string(mapblock) ..
        " type: " .. info.type .. " key: " .. info.build_key
    else
      txt = "no grid data available"
    end

    eco_util.display_mapblock_at_pos(pos, txt, 15)

    return true, txt
  end
})
