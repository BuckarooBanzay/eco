
building_lib.register_placement({
	name = "simple",
	check = function(mapblock_pos)
		local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
		if mapblock_data and mapblock_data.building and mapblock_data.building.name then
			return false, "already occupied"
		end
		return true
	end,
	place = function(mapblock_pos, building_def)
		local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)

		mapblock_lib.deserialize(mapblock_pos, building_def.schematic, {
			use_cache = true
		})

		mapblock_data.building = {
			name = building_def.name
		}

		-- write data back
		mapblock_lib.set_mapblock_data(mapblock_pos, mapblock_data)
	end
})
