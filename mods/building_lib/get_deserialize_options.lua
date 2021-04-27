
function building_lib.get_deserialize_options(mapblock_pos, building_def)
	if type(building_def.deserialize_options) == "function" then
		return building_def.deserialize_options(mapblock_pos, building_def)
	elseif type(building_def.deserialize_options) == "table" then
		return building_def.deserialize_options
	end

	-- default
	return {
		use_cache = true
	}
end
