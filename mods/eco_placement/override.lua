-- go over all items and register eco functions if the definition is found
minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_items) do
		if def.eco then
			if def.eco.mode == "simple" then
				minetest.override_item(name, eco_placement.place_simple(def))
			elseif def.eco.mode == "connected_rotate" then
				minetest.override_item(name, eco_placement.place_connected_rotate(def))
			end
		end
	end
end)
