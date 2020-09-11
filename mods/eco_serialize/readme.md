
Schematic serialization and placement library with mapblock granularity

Features:
* Mapblock granular schemas
* Efficient and complete schema format (nodeid/param1/param2/nodetimer/inventory and metadata are saved)
* Async saving/loading
* Transformations (rotate/replace)
* Additive/Overwrite mode (replace everything on load or just air)

# Chat commands

* **/pos1 [set|show]** sets or shows the current position1
* **/pos2 [set|show]** sets or shows the current position2
* **/save_schema [name]** saves the marked region under `<worlddir>/eco_schems/<name>`
* **/load_schema [name]** loads the schema at current pos1
* **/load_schema_add [name]** loads the schema at current pos1 but only replaces existing air nodes

# On-disk format

Structure of the on-disk schema format:

```
 + <worlddir>
  + eco_schems
   + <name>
    + manifest.json (schema metadata, size, nodeids)
    + mapblock_<num>.bin (compressed binary data of nodeids/param1 and param2)
    + mapblock_<num>.metadata.json (block metadata/inventories in json format)
```

# Lua api

**Note**: positions are in block coordinates (from -31000 to 31000 x/y/z) and are rounded internally to mapblocks

## eco_serialize.serialize

Writes the selected world nodes to disk

```lua
eco_serialize.serialize(pos1, pos2, schema_dir)
```

## eco_serialize.deserialize

Reads from the disk and places schematics inworld

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
