minetest.register_chatcommand("mapgen_info", {
	func = function(name)
    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()
    local mapblock = eco_util.get_mapblock(pos)
    local info = eco_mapgen.get_info(mapblock)
    local txt = "mapblock: " .. minetest.pos_to_string(mapblock) ..
      " type: " .. info.type .. " direction: " .. (info.direction or "<none>")

    eco_util.display_mapblock_at_pos(pos, txt, 15)

    return true, txt
  end
})

minetest.register_chatcommand("mapgen_regenerate", {
  description = "Regenerates the mapblock to mapgen default",
  privs = { server=true },
	func = function(name)
    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()
    local mapblock = eco_util.get_mapblock(pos)

    eco_mapgen.place_mapblock(mapblock)

    return true
  end
})
