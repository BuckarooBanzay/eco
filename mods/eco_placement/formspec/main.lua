local FORMNAME = "eco_placement_formspec"

function eco_placement.show_placement_formspec(playername)
  local player = minetest.get_player_by_name(playername)

  if not player then
    return
  end

  local formspec = [[
    size[16,12;]
    image_button_exit[0,0;2,2;eco_placement_street.png;streets;Streets]
    image_button_exit[15,11;1,1;eco_placement_abort.png;exit;Exit]
  ]]

  minetest.show_formspec(playername, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end

	local playername = player:get_player_name()

  print(FORMNAME, playername, dump(fields))
  if fields.streets then
    minetest.after(0.1, eco_placement.show_streets_formspec, playername)
    return true
  end
end)
