

# Cityblock design

Get/Set:

```lua
local mapblock_pos = { x=0, y=10, z=0 }

-- read
local cityblock = eco_api.get_cityblock(mapblock_pos)

-- modify
cityblock.whatever = 1234

-- write
eco_api.set_cityblock(mapblock_pos, cityblock)

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