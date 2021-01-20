minetest.register_craftitem("eco_buildings:house", {
	description = "Simple house",
	inventory_image = "default_mese_crystal.png",
	on_use = function()
		-- preview
	end,

	on_secondary_use = function(itemstack)
		-- build
		itemstack:take_item()
		return itemstack
	end

})
