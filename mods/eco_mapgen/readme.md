
## Api

```lua
local mapgen_info = eco_mapgen.get_info(mapblock_pos)

mapgen_info = {
	-- solid = true
	slope = true,
	slope_inner = true,
	rotation = 90
}
```

`eco_data` structure:
```lua
{
	mapgen_info = {
		slope = true,
		rotation = 90
	}
}
```