function eco_grid.get_influence(mapblock, range)
  local influence = {}

  for x=-range,range do
    for z=-range,range do
      local current_mapblock = {
        x = mapblock.x + x,
        y = mapblock.y,
        z = mapblock.z + z
      }

      local grid = eco_grid.get_mapblock(current_mapblock)
      if grid and grid.build_key then
        local building_def = eco_api.get_building(grid.build_key)
        if building_def and building_def.influence then
          for k, v in pairs(building_def.influence) do
            if not influence[k] then
              influence[k] = v
            else
              influence[k] = influence[k] + v
            end
          end
        end
      end
    end
  end

  return influence
end

minetest.register_chatcommand("influence", {
	func = function(name, param)
    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()
    local mapblock = eco_util.get_mapblock(pos)
    local range = 5
    local param_num = tonumber(param)
    if param_num and param_num > 0 then
      range = tonumber(param)
    end

    if range > 10 or range < 0 then
      return false, "Range limit exceeded!"
    end

    local influence = eco_grid.get_influence(mapblock, range)
    local txt = "Influence at mapblock " .. minetest.pos_to_string(mapblock) ..
      " with range " .. range .. ": "

    for k, v in pairs(influence) do
      txt = txt .. " " .. k .. " = " .. v
    end

    return true, txt
  end
})
