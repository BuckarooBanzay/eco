
Environment influence mod for the eco game

# Api

```lua
-- influence field in buildings:
building_lib.register_building("buildings:very_noisy_thing", {
    -- other fields omitted
    influence = {
        noisy = 5
    }
})

-- get groups
local influence_groups = eco_influence.get_groups({ x=0, y=0, z=0 })
influence_groups = {
    noisy = 2, -- 3 tiles away from above building
    public_transportation = 1
}

-- get single value
local influence = eco_influence.get({ x=0, y=0, z=0 }, "noisy")
influence = 1 -- defaults to 0

-- clear region or single position
-- NOTE: only to be used if buildings were manually removed (WE, other maptools)
eco_influence.clear({ x=-5, y=-5, z=-5 }, { x=5, y=5, z=5 })
```