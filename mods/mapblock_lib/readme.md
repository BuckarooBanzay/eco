

## Api

```lua
-- main api
mapblock_lib.serialize(block_pos, filename)
mapblock_lib.deserialize(mapblock_pos, filename, options)

-- mapblock data storage
mapblock_lib.get_mapblock_data(mapblock_pos)
mapblock_lib.set_mapblock_data(mapblock_pos, data)
mapblock_lib.merge_mapblock_data(mapblock_pos, data)

-- utils
mapblock_lib.get_mapblock(pos)
mapblock_lib.get_mapblock_bounds_from_mapblock(block_pos)
mapblock_lib.get_mapblock_bounds(pos)
mapblock_lib.get_mapblock_center(pos)

-- display
mapblock_lib.display_mapblock_at_pos(pos, text, timeout)
mapblock_lib.display_mapblock(mapblock, text, timeout)
```
