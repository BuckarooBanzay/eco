
Schematic serialization and placement library

# Api

## eco_serialize.serialize

```lua
eco_serialize.serialize(pos1, pos2, schema_dir)
```

## eco_serialize.deserialize

```lua
eco_serialize.deserialize(pos, schema_dir, options)

options = {
  -- set to true if the schematic is used a lot
  use_cache = false,

  -- async/sync mode (mapgen = sync)
  sync = false,

  -- mode
  mode = "replace", -- replace/add

  -- transformations
  transform = {
    rotate = {
      axis = "y",
      angle = 90
    },
    replace = {
      ["default:stone"] = "default:mese"
    }
  }
}
```
