
## Api

```lua
local success, message = building_lib.do_build(mapblock_pos, building_def)
local success, message = building_lib.can_build(mapblock_pos, building_def)

building_lib.register({
	name = "buildings:my_building",
	placement = "simple",
	schematic = "",
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
	place = function(mapblock_pos, building_def) end
})
```
