
## Api

```lua
local success, message = building_lib.do_build(mapblock_pos, building_def)
local success, message = building_lib.can_build(mapblock_pos, building_def)
local building_def = building_lib.get_building_at_pos(mapblock_pos)
local groups = building_lib.get_groups_at_pos(mapblock_pos)

local size = building_lib.get_size(building_def)
-- single mapblock size: { x=0, y=0, z=0 }

building_lib.register({
	name = "buildings:my_building",
	placement = "simple",
	schematic = "",
	-- optional groups
	groups = {
		x = true
	},
	can_build = function(mapblock_pos, building_def)
		-- building-related checks
		if ok then
			return true
		else
			return false, "not gonna happen here!"
		end
	end
})

building_lib.register_placement({
	name = "simple",
	check = function(mapblock_pos, building_def)
		-- placement-related checks
		if ok then
			return true
		else
			return false, "not gonna happen here!"
		end
	end,
	place = function(mapblock_pos, building_def) end,
	after_place = function(mapblock_pos, building_def) end
})
```
