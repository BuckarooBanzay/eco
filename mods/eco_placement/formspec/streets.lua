local FORMNAME = "eco_placement_formspec_streets"

-- playername -> list
local selection_lists = {}
local selected_item = {}

function eco_placement.show_streets_formspec(playername)
  local player = minetest.get_player_by_name(playername)

  if not player then
    return
  end

  local list = ""
  selection_lists[playername] = {}
  local i = 1

  for _, def in pairs(eco_api.get_building_by_type("street")) do
    selection_lists[playername][i] = def
    i = i + 1

    local color = "#FFFFFF"
    list = list .. "," .. color .. "," ..
      minetest.formspec_escape(def.name) .. "," ..
      def.cost .. "," ..
      minetest.formspec_escape(def.description)
  end

  list = list .. ";]"

  local formspec = [[
    size[16,12;]
    no_prepend[]
    tablecolumns[color;text;text;text]
    table[0,1;15.7,9.5;list;#999,Name,Cost,Description]] .. list .. [[
    image_button_exit[14,11;1,1;eco_placement_abort.png;exit;Exit]
    image_button_exit[15,11;1,1;eco_placement_ok.png;ok;Ok]
  ]]

  minetest.show_formspec(playername, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end

	local playername = player:get_player_name()

  if fields.list then
		local parts = fields.list:split(":")
		if parts[1] == "CHG" then
			selected_item[playername] = tonumber(parts[2]) - 1
		end
	end

  if fields.ok then
    local index = selected_item[playername]
    if not index then
      return
    end

    local def = selection_lists[playername][index]
    if not def then
      return
    end

    local itemstack = player:get_wielded_item()
    if itemstack:get_name() ~= "eco_placement:wand" then
      return
    end

    local meta = itemstack:get_meta()
    meta:set_string("description", "Placement: " .. def.name)
    meta:set_string("build_type", "street")
    meta:set_string("build_key", def.key)
    if def.size then
      meta:set_string("size_x", def.size.x)
      meta:set_string("size_z", def.size.z)
    else
      meta:set_string("size_x", 1)
      meta:set_string("size_z", 1)
    end
    player:set_wielded_item(itemstack)
  end
end)
