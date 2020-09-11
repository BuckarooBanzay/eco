function eco_placement.place_simple(place_def)
  return function(build_def, mapblock, playername)
    print(playername .. " places '" .. build_def.name .. "' to " .. minetest.pos_to_string(mapblock) ..
      " Schema: " .. dump(place_def))
  end
end
