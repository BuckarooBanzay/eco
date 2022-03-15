
building_lib.register_placement({
	name = "multi",
	check = function(mapblock_pos, building_def)
		local _, size = mapblock_lib.get_multi_size(building_def.schematic)
		for x=0, size.x-1 do
			for y=0, size.y-1 do
				for z=0, size.z-1 do
					if building_lib.get_building_at_pos(vector.add(mapblock_pos, {x=x, y=y, z=z})) then
						return false, "already occupied"
					end
				end
			end
		end

		return true
	end,
	place = function(mapblock_pos, building_def)
		local options = building_lib.get_deserialize_options(mapblock_pos, building_def)

		mapblock_lib.deserialize_multi(mapblock_pos, building_def.schematic, {
			mapblock_options = function()
				return options
			end
		})

		local _, size = mapblock_lib.get_multi_size(building_def.schematic)
		local affected_offsets = {}
		for x=0, size.x-1 do
			for y=0, size.y-1 do
				for z=0, size.z-1 do
					table.insert(affected_offsets, {x=x, y=y, z=z})
				end
			end
		end

		return affected_offsets
	end,
	get_size = function(building_def)
		local _, size = mapblock_lib.get_multi_size(building_def.schematic)
		return size
	end
})
