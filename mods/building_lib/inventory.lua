
function building_lib.get_inventory(mapblock_pos)
	local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
	mapblock_data.inventory = mapblock_data.inventory or {}
	return {
		get = function(name)
			return mapblock_data.inventory[name] or 0
		end,
		set = function(name, value)
			mapblock_data.inventory[name] = value
			mapblock_lib.set_mapblock_data(mapblock_pos, mapblock_data)
		end,
		add = function(name, value)
			mapblock_data.inventory[name] = (mapblock_data.inventory[name] or 0) + value
			mapblock_lib.set_mapblock_data(mapblock_pos, mapblock_data)
		end
	}
end
