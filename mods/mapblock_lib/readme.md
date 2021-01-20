

## Api

```lua
-- main api
mapblock_lib.serialize(block_pos, filename)
mapblock_lib.deserialize(mapblock_pos, filename, options)

options = {
	-- caches the on-disk file, useful for repetitive mapgen events
	use_cache = false,
	transform = {
		-- rotate the mapblock around the given axis with the angle (90, 180, 270)
		rotate = {
			angle = 90,
			axis = "y"
		},
		-- replace certain nodes with others
		replace = {
			["default:dirt"] = "default:mese"
		}
	}
}

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
