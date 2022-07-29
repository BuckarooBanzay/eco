
function building_lib.get_inventory(mapblock_pos)
	local mapblock_data = building_lib.store:get(mapblock_pos)
	local inventory = mapblock_data.inventory or {}
	return {
		get = function(name)
			return inventory[name] or 0
		end,
		set = function(name, value)
			inventory[name] = value
			building_lib.store:merge(mapblock_pos, {
				inventory = inventory
			})
		end,
		add = function(name, value)
			inventory[name] = (inventory[name] or 0) + value
			building_lib.store:merge(mapblock_pos, {
				inventory = inventory
			})
		end
	}
end
