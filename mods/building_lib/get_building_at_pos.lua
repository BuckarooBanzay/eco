
function building_lib.get_building_at_pos(mapblock_pos)
	local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
	if mapblock_data and mapblock_data.building then
		return building_lib.buildings[mapblock_data.building.name]
	end
end
