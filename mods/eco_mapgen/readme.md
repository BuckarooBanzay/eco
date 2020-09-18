
mapgen for the eco game

# Chat commands

* **/mapgen_info** Returns data from the current mapblock

# Lua api

## place_mapblock

Places or restores the specified mapblock at the position

```lua
eco_mapgen.place_mapblock({ x=0, y=3, z=0 })
```

## get_info

```lua
-- retrieve mapgen metadata
local info = eco_mapgen.get_info({ x=0, y=10, z=20 })
```

No mapgen object there (empty)
```lua
{
  type = "none"
}
```

Flat surface
```lua
{
  type = "flat"
}
```

Slope
```lua
{
  type = "slope",
  direction = "x-"
}
```

Inner slope / corner
```lua
{
  type = "slope_inner",
  direction = "x-z-"
}
```

Outer slope / corner
```lua
{
  type = "slope_outer",
  direction = "x-z-"
}
```
