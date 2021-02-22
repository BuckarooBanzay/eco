
function eco_mapgen.count_resources(mapblock_pos, radius)
	local resources = {}
	for x=-radius, radius do
		for y=-radius, radius do
			for z=-radius, radius do
				local offset_pos = vector.add(mapblock_pos, {x=x, y=y, z=z})
				local mapblock_data = mapblock_lib.get_mapblock_data(offset_pos)
				if mapblock_data and mapblock_data.resources then
					for key, value in pairs(mapblock_data.resources) do
						resources[key] = (resources[key] or 0) + value
					end
				end
			end
		end
	end

	return resources
end
