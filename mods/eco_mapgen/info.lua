
function eco_mapgen.get_info(mapblock)
  local height = eco_mapgen.get_mapblock_height(mapblock)

  local biome
  if mapblock.y <= eco_mapgen.get_water_height() then
    -- below water
    biome = "water"
  else
    -- above water
    biome = "grass"
  end

  if mapblock.y ~= height then
    return { type = "none", biome = biome }
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
    return { type = "flat", biome = biome }
  end

  -- straight slopes
  if hm[-1][0] and not hm[1][0] and not hm[0][-1] and not hm[0][1] then
    return { type = "slope", direction = "x-", biome = biome }
  elseif not hm[-1][0] and hm[1][0] and not hm[0][-1] and not hm[0][1] then
    return { type = "slope", direction = "x+", biome = biome }
  elseif not hm[-1][0] and not hm[1][0] and hm[0][-1] and not hm[0][1] then
    return { type = "slope", direction = "z-", biome = biome }
  elseif not hm[-1][0] and not hm[1][0] and not hm[0][-1] and hm[0][1] then
    return { type = "slope", direction = "z+", biome = biome }
  end

  -- z- / x- / z+ / x+
  if hm[0][-1] and hm[-1][0] and not hm[0][1] and not hm[1][0] then
    return { type = "slope_inner", direction = "x-z-", biome = biome }
  elseif not hm[0][-1] and hm[-1][0] and hm[0][1] and not hm[1][0] then
    return { type = "slope_inner", direction = "x-z+", biome = biome }
  elseif not hm[0][-1] and not hm[-1][0] and hm[0][1] and hm[1][0] then
    return { type = "slope_inner", direction = "x+z+", biome = biome }
  elseif hm[0][-1] and not hm[-1][0] and not hm[0][1] and hm[1][0] then
    return { type = "slope_inner", direction = "x+z-", biome = biome }
  end

  if hm[-1][-1] and not hm[-1][1] and not hm[1][1] and not hm[1][-1] then
    return { type = "slope_outer", direction = "x-z-", biome = biome }
  elseif not hm[-1][-1] and hm[-1][1] and not hm[1][1] and not hm[1][-1] then
    return { type = "slope_outer", direction = "x-z+", biome = biome }
  elseif not hm[-1][-1] and not hm[-1][1] and hm[1][1] and not hm[1][-1] then
    return { type = "slope_outer", direction = "x+z+", biome = biome }
  elseif not hm[-1][-1] and not hm[-1][1] and not hm[1][1] and hm[1][-1] then
    return { type = "slope_outer", direction = "x+z-", biome = biome }
  end

  return { type = "flat", biome = biome }

end


minetest.register_chatcommand("mapgen_info", {
	func = function(name)
    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()
    local mapblock = eco_util.get_mapblock(pos)
    local info = eco_mapgen.get_info(mapblock)
    local txt = "mapblock: " .. minetest.pos_to_string(mapblock) ..
      " type: " .. info.type .. " direction: " .. (info.direction or "<none>") ..
      " biome: " .. (info.biome or "<unknown>")

    eco_util.display_mapblock_at_pos(pos, txt, 15)

    return true, txt
  end
})
