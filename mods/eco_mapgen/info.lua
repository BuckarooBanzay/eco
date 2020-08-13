
function eco_mapgen.get_info(mapblock)
  local height = eco_mapgen.get_mapblock_height(mapblock)

  if mapblock.y ~= height then
    return { type = "none" }
  end

  -- collect neighbor elevations and count
  local hm = {}
  local elevated_neighbor_count = 0
  for x=-1,1 do
    hm[x] = hm[x] or {}
    for z=-1,1 do
      local neighbor_height = eco_mapgen.get_mapblock_height({ x=mapblock.x+x, z=mapblock.z+z })

      if neighbor_height > height then
        -- neighbor is higher
        hm[x][z] = true
        elevated_neighbor_count = elevated_neighbor_count + 1
      end
    end
  end

  if elevated_neighbor_count == 0 then
    return { type = "flat" }
  end

  -- straight slopes
  if hm[-1][0] and not hm[1][0] and not hm[0][-1] and not hm[0][1] then
    return { type = "slope", direction = "x-" }
  elseif not hm[-1][0] and hm[1][0] and not hm[0][-1] and not hm[0][1] then
    return { type = "slope", direction = "x+" }
  elseif not hm[-1][0] and not hm[1][0] and hm[0][-1] and not hm[0][1] then
    return { type = "slope", direction = "z-" }
  elseif not hm[-1][0] and not hm[1][0] and not hm[0][-1] and hm[0][1] then
    return { type = "slope", direction = "z+" }
  end

  -- z- / x- / z+ / x+
  if hm[0][-1] and hm[-1][0] and not hm[0][1] and not hm[1][0] then
    return { type = "slope_inner", direction = "x-z-" }
  elseif not hm[0][-1] and hm[-1][0] and hm[0][1] and not hm[1][0] then
    return { type = "slope_inner", direction = "x-z+" }
  elseif not hm[0][-1] and not hm[-1][0] and hm[0][1] and hm[1][0] then
    return { type = "slope_inner", direction = "x+z+" }
  elseif hm[0][-1] and not hm[-1][0] and not hm[0][1] and hm[1][0] then
    return { type = "slope_inner", direction = "x+z-" }
  end

  if hm[-1][-1] and not hm[-1][1] and not hm[1][1] and not hm[1][-1] then
    return { type = "slope_outer", direction = "x-z-" }
  elseif not hm[-1][-1] and hm[-1][1] and not hm[1][1] and not hm[1][-1] then
    return { type = "slope_outer", direction = "x-z+" }
  elseif not hm[-1][-1] and not hm[-1][1] and hm[1][1] and not hm[1][-1] then
    return { type = "slope_outer", direction = "x+z+" }
  elseif not hm[-1][-1] and not hm[-1][1] and not hm[1][1] and hm[1][-1] then
    return { type = "slope_outer", direction = "x+z-" }
  end

  return { type = "flat" }

end


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
