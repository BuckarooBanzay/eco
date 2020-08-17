
local money_hud = {}

minetest.register_on_joinplayer(function(player)
  money_hud[player:get_player_name()] = player:hud_add({
    hud_elem_type = "text",
    position = {
      x = 0.5,
      y = 0.5
    },
    text = ""
  })
end)

local function update_player(player)
  local meta = player:get_meta()
  player:hud_change(money_hud[player:get_player_name()], "text", meta:get_int("money"))
end

local function update()
  for _, player in ipairs(minetest.get_connected_players()) do
    update_player(player)
  end

  minetest.after(1, update)
end

minetest.after(1, update)
