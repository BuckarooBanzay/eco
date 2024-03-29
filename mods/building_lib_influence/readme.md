
Environment influence mod

**NOTE**: works in "superblocks" of 10^3 mapblocks

# Api

```lua
-- influence field in buildings:
building_lib.register_building("buildings:very_noisy_thing", {
    -- other fields omitted
    influence = {
        noise = {
            value = 5, -- base-value at origin-superblock
            reduction = 1 -- reduction in each neighboring superblock
        }
    }
})

--[[
Example:
* influence = { x = { value = 2, reduction = 1 } }
* superblock at origin: { x = 2 }
* next superblock 10 mapblocks away: { x = 1 }

General rule: node-distance = value * 160

Two buildings with a value of "2" and reduction of "1" placed near each other (2d presentation):

  -- -- -- -- -- --
 |+1|+1|+1|  |  |  |
  -- -- -- -- -- --
 |+1|+2|+1|  |  |  |
  -- -- -- -- -- --
 |+1|+1|+2|+1|+1|  |
  -- -- -- -- -- --
 |  |  |+1|+2|+1|  |
  -- -- -- -- -- --
 |  |  |+1|+1|+1|  |
  -- -- -- -- -- --

A building with a value of "3" and reduction of "1"

  -- -- -- -- -- --
 |+1|+1|+1|+1|+1|  |
  -- -- -- -- -- --
 |+1|+2|+2|+2|+1|  |
  -- -- -- -- -- --
 |+1|+2|+3|+2|+1|  |
  -- -- -- -- -- --
 |+1|+2|+2|+2|+1|  |
  -- -- -- -- -- --
 |+1|+1|+1|+1|+1|  |
  -- -- -- -- -- --


--]]

-- get groups
local influence_groups = building_lib_influence.get_groups({ x=0, y=0, z=0 })
influence_groups = {
    noisy = 2, -- 3 tiles away from above building
    public_transportation = 1
}
-- defaults to {} if no groups found

-- get single value
local influence = building_lib_influence.get({ x=0, y=0, z=0 }, "noisy")
influence = 1 -- defaults to 0

-- clear region or single position of influence data
-- NOTE: only to be used if buildings were manually removed (WE and other maptools)
building_lib_influence.clear({ x=-5, y=-5, z=-5 }, { x=5, y=5, z=5 })
```

## Chat commands

* `/influence_info`

# License

* Code: `MIT`
* Textures: `CC-BY-SA-3.0`