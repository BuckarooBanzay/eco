
Building interconnect mod

# Api

```lua
-- building with an interconnection
building_lib.register_building("buildings:water_pump", {
    -- other fields omitted
    interconnect = {
        producer = {
            water = 200
        }
    }
})

building_lib.register_building("buildings:water_pipe", {
    -- other fields omitted
    interconnect = {
        connects = {
            water = true
        }
    }
})

building_lib.register_building("buildings:water_distribution", {
    -- other fields omitted
    interconnect = {
        consumer = {
            water = 50
        }
    }
})

local mapblock_pos = { x=0, y=0, z=0 }
local connection_type = "water"

-- internal api
local network = building_lib_interconnect.get_network(mapblock_pos, connection_type)
network = {
    consumers = {
        { x=2, y=0, z=0 }
    },
    producers = {
        { x=3, y=0, z=0 }
    }
}

-- external api
local is_powered = building_lib_interconnect.is_powered(mapblock_pos, connection_type)

```

# License

* Code: `MIT`
* Textures: `CC-BY-SA-3.0`