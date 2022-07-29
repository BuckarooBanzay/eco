
# Building register and placement library

## Api

```lua
-- check if something can be built there
local success, message = building_lib.can_build(mapblock_pos, building_def)

-- build it there
local success, message = building_lib.do_build(mapblock_pos, building_def, callback)

-- get the building at the position or nil
local building_def = building_lib.get_building_at_pos(mapblock_pos)

-- get the final building size ({x=1,y=1,z=1} means 1 mapblock)
local size = building_lib.get_size(mapblock_pos, building_def)

-- returns the opposite corners of the to-build area
local pos1, pos2 = building_lib.get_corners(mapblock_pos, building_def)

-- get all groups of the building on the mapblock position (returns {} if no building found)
local groups = building_lib.get_groups(mapblock_pos)

-- registers a placeable building
building_lib.register_building("buildings:my_building", {
	placement = "simple",
	conditions = {
		-- OR
		on_flat_surface = true,
		on_slope = true,
		-- alternatively: OR and AND combined
		{ on_slope = true, on_biome = "grass" },
		{ on_flat_surface = true, on_biome = "water" },
	},
	schematic = "",
	-- optional groups attribute
	groups = {
		building = true
	}
})

-- registers a placement type (connected, simple, etc)
building_lib.register_placement("simple", {
	check = function(self, mapblock_pos, building_def)
		-- placement-related checks
		if ok then
			return true
		else
			return false, "not gonna happen here!"
		end
	end,
	-- place the building
	place = function(mself, apblock_pos, building_def, callback) end,
	-- return the size of the building if it would be placed there
	get_size = function(self, mapblock_pos, building_def)
		return { x=1, y=1, z=1 }
	end,
	-- validation function for startup-checks (optional)
	validate = function(self, building_def)
		return success, err_msg
	end
})

-- registers a condition that checks for certain world conditions
building_lib.register_condition("on_flat_surface", {
    can_build = function(mapblock_pos, building_def, flag_value)
		return false, msg
    end
})
```

## Chat commands

* `/building_place <building_name>`
* `/building_check <building_name>`
* `/building_info`