local FORMNAME = "eco_placement_formspec"

function eco_placement.show_placement_formspec(playername)
  local player = minetest.get_player_by_name(playername)

  if not player then
    return
  end

  local formspec = [[
    size[16,12;]
    button_exit[12,11;4,1;exit;Exit]
  ]]

  minetest.show_formspec(playername, FORMNAME, formspec)
end


minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end

	local playername = player:get_player_name()

  print(FORMNAME, playername, dump(fields))
end)
