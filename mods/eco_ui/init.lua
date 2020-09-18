
minetest.register_on_joinplayer(function()
  -- TODO: setu phud items here
end)

local function update_player()
  -- TODO: update hud items here
end

local function update()
  for _, player in ipairs(minetest.get_connected_players()) do
    update_player(player)
  end

  minetest.after(1, update)
end

minetest.after(1, update)
