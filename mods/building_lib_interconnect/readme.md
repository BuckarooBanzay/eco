
Building interconnect mod

# Api

```lua
-- pipe connects water in +/-x direction
building_lib.register_building("buildings:water_pipe", {
    -- other fields omitted
    interconnect = {
        connects = {
            water = {
                { x=1, y=0, z=0 },
                { x=-1, y=0, z=0 }
            }
        }
    }
})

-- pump connects on x+ side
building_lib.register_building("buildings:water_pump", {
    -- other fields omitted
    interconnect = {
        connects_to = {
            water = {
                { x=1, y=0, z=0 }
            }
        }
    }
})

-- api
local mapblock_pos = { x=0, y=0, z=0 }
local connection_type = "water"

local pos_list = building_lib_interconnect.get_connections(mapblock_pos, connection_type)
network = {
    { x=0, y=0, z=0 },
    ...
}

```

# License

* Code: `MIT`
* Textures: `CC-BY-SA-3.0`