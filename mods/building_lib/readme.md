
## Api

```lua
local success, message = building_lib.do_build(mapblock_pos, building_def)
local success, message = building_lib.can_build(mapblock_pos, building_def)
local building_def = building_lib.get_building_at_pos(mapblock_pos)
local groups = building_lib.get_groups_at_pos(mapblock_pos)

local size = building_lib.get_size(building_def)
-- single mapblock size: { x=1, y=1, z=1 }

-- registers a placeable building
building_lib.register({
	name = "buildings:my_building",
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
	-- optional groups
	groups = {
		x = true
	},
	-- optional deserialize options as table or function
	-- deserialize_options = {}
	deserialize_options = function(mapblock_pos, building_def)
		return {}
	end,
	can_build = function(mapblock_pos, building_def)
		-- building-related checks
		if ok then
			return true
		else
			return false, "not gonna happen here!"
		end
	end
})

-- registers a placement type (connected, simple, etc)
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
	after_place = function(mapblock_pos, building_def) end,
	-- validation function for startup-checks (optional)
	validate = function(building_def)
		return success, err_msg
	end
})

-- registers a condition that checks for certain world conditions
building_lib.register_condition({
    name = "on_flat_surface",
    can_build = function(mapblock_pos, building_def, flag_value)
		return false, msg
    end
})
```

## Mapblock data

```lua
{
	building = {
		name = "eco_buildings:simple_house",
		rotation = 0
	}
}
```