function eco_placement.place_connected_street(place_def)
  return function(build_def, mapblock, playername)
    print(playername .. " places connected street '" .. build_def.name .. "' to " .. minetest.pos_to_string(mapblock) ..
      " Schema: " .. dump(place_def))
  end
end
