
## Api


### Public

```lua
local resources = eco_mapgen.count_resources(mapblock_pos, radius)

eco_mapgen.register_biome({
	name = "grass",

	-- manual matcher, overrides _every_ other biome if it returns true
	match = function(mapblock_pos, info)
		return mapblock_pos.y >= 0 and mapblock_pos.y < 4 and info.type ~= "none" and info.type ~= "underground"
	end,

	-- table based matcher, picked if it matches the best with the current biome_data
	match = {
		temperature = 50, -- 0 -100
		humidity = 40, -- 0 - 100
	},

	flat = MP .. "/schematics/base/grass_flat",

	slope_upper = MP .. "/schematics/base/grass_slope_upper",
	slope_lower = MP .. "/schematics/base/grass_slope_lower",

	slope_inner_upper = MP .."/schematics/base/grass_slope_inner_corner_upper",
	slope_inner_lower = MP .."/schematics/base/grass_slope_inner_corner_lower",

	slope_outer_upper = MP .."/schematics/base/grass_slope_outer_corner_upper",
	slope_outer_lower = MP .."/schematics/base/grass_slope_outer_corner_lower"
})
```


### Internals

```lua
-- biome data
local biome_data = eco_mapgen.get_biome_data({x=1, z=4})
biome_data = {
	height = 2,
	temperature = 10,
	humidity = 20
}

```

## Mapblock data

```lua
{
	mapgen_info = {
		type = "slope_lower",
		direction = "x+"
	}
}
```