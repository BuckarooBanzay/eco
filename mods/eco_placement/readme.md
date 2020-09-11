
eco placement api


# Lua api


## place_simple

factory for the `building_def.on_place` definition.
Returns: `function(building_def, mapblock, playername)`

```lua
-- simple placement, gets rotated randomly
local on_place = eco_placement.place_simple({
  directory = "modpath/schematics/simple_park"
})

-- specify multiple replacements that get chosen randomly and disable rotation
local on_place = eco_placement.place_simple({
  directory = "modpath/schematics/simple_park",
  disable_rotation = true,
  replacements = {
    {},
    {
      ["default:stone_block"] = "default:desert_sandstone_block",
      ["default:tree"] = "default:acacia_tree",
      ["default:leaves"] = "default:acacia_leaves"
    },
})
```
