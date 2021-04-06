
function building_lib.get_size(building_def)
	local placement = building_lib.placements[building_def.placement]
	if not placement or type(placement.get_size) ~= "function" then
		-- default to one mapblock cube
		return {x=1, y=1, z=1}
	end

	return placement.get_size(building_def)
end
