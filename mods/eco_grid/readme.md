
per mapblock metadata storage (grid)

# Lua api

```lua
-- retrieve data (a table object or nil
local data = eco_grid.get_mapblock({ x=0, y=2, z=0 })

-- set data (table type)
eco_grid.set_mapblock({ x=0, y=2, z=0 }, {
  here_be_dragons = true
})

```
