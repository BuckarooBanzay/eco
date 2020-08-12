
-- player positions map
local pos1_player_map = {}
local pos2_player_map = {}

local position_fn = function(i, pos_map)
  return function(name, params)
    local player = minetest.get_player_by_name(name)
    if params == "set" then
      -- set position
      local pos = player:get_pos()
      pos_map[name] = vector.round(pos)
      eco_util.display_mapblock_at_pos(pos_map[name])
      return true, "Position " .. i .. " set at " .. minetest.pos_to_string(pos_map[name])

    elseif pos_map[name] then
      -- show position
      eco_util.display_mapblock_at_pos(pos_map[name])
      return true, "Position " .. i .. " is at " .. minetest.pos_to_string(pos_map[name])

    else
      -- no position
      return false, "no position " .. i .. " set"

    end
  end
end

minetest.register_chatcommand("pos1", {
  privs = { eco_dev = true },
  params = "[show|set]",
	func = position_fn(1, pos1_player_map)
})

minetest.register_chatcommand("pos2", {
  privs = { eco_dev = true },
  params = "[show|set]",
	func = position_fn(2, pos2_player_map)
})


minetest.register_chatcommand("save_schema", {
  privs = { eco_dev = true },
	func = function(name, params)
    local pos1 = pos1_player_map[name]
    local pos2 = pos2_player_map[name]
    if not pos1 or not pos2 then
      return false, "set pos1 and pos2 before saving"
    end

    if not params or params == "" then
      return false, "specify a name for the schema"
    end

    eco_serialize.serialize(pos1, pos2, minetest.get_worldpath() .. "/eco_schems/" .. params)
		return true
  end
})

minetest.register_chatcommand("load_schema", {
  privs = { eco_dev = true },
	func = function(name, params)
    local pos1 = pos1_player_map[name]
    if not pos1 then
      return false, "set pos1 before loading"
    end

    if not params or params == "" then
      return false, "specify a name for the schema"
    end

    eco_serialize.deserialize(pos1, minetest.get_worldpath() .. "/eco_schems/" .. params, {
      transform = {
        rotate = {
          axis = "y",
          angle = 90
        }
      }
    })
		return true
  end
})

-- cleanup
minetest.register_on_leaveplayer(function(player)
  local playername = player:get_player_name()
  pos1_player_map[playername] = nil
  pos2_player_map[playername] = nil
end)
