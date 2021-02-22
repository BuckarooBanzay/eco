
function building_lib.get_size(building_def)
	if building_def.placement == "simple" and building_def.placement == "connected" then
		return {x=0, y=0, z=0}
	end
	error("unknown placement: " .. building_def.placement)
end
