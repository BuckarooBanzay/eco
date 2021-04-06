
building_lib.register_placement({
	name = "multi",
	check = function()
		--TODO
		return true
	end,
	place = function()
		--TODO
	end,
	get_size = function(building_def)
		local _, size = mapblock_lib.get_multi_size(building_def.schematic)
		return size
	end
})
