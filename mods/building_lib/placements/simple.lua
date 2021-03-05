
building_lib.register_placement({
	name = "simple",
	check = function(mapblock_pos)
		if building_lib.get_building_at_pos(mapblock_pos) then
			return false, "already occupied"
		end
		return true
	end,
	place = function(mapblock_pos, building_def)
		mapblock_lib.deserialize(mapblock_pos, building_def.schematic, {
			use_cache = true
		})
	end
})