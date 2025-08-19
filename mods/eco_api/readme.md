

# superblock design

Get/Set:

```lua
local mapblock_pos = { x=0, y=10, z=0 }

-- read
local superblock = eco_api.get_superblock(mapblock_pos)

-- modify
superblock.whatever = 1234

-- write
eco_api.set_superblock(mapblock_pos, superblock)

```



Layout:

```json
{
    "stats": {
        "noise": 5.5,
        "residents": 3
    }
}
```

Fields:

* `stats` current map with statistics (noise, residents, industry, etc)