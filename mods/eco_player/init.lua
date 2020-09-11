
minetest.register_on_joinplayer(function(player)
  local meta = player:get_meta()
  local eco_onboarding = meta:get_int("eco_onboarding")

  if eco_onboarding == 0 then
    -- give initial money to player
    meta:set_int("money", 150000)
  end

  local inv = player:get_inventory()
  local main_list = inv:get_list("main")

  local wand_found = false

  for _, stack in ipairs(main_list) do
    if stack:get_name() == "eco_wand:wand" then
      wand_found = true
      break
    end
  end

  if not wand_found then
    main_list[1] = ItemStack("eco_wand:wand")
    inv:set_list("main", main_list)
  end


end)
