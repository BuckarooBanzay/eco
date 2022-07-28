
building_lib.register_placement({
	name = "simple",
	check = function(_, mapblock_pos)
		if building_lib.get_building_at_pos(mapblock_pos) then
			return false, "already occupied"
		end
		return true
	end,
	place = function(_, mapblock_pos, building_def, callback)
		local catalog = mapblock_lib.get_catalog(building_def.catalog)
		catalog:deserialize_all(mapblock_pos, { callback = callback })
	end,
	get_size = function(_, _, building_def)
		local catalog = mapblock_lib.get_catalog(building_def.catalog)
		return catalog:get_size()
	end,
	validate = function(_, building_def)
		local catalog, err = mapblock_lib.get_catalog(building_def.catalog)
		if catalog then
			return true
		else
			return false, err
		end
	end
})
