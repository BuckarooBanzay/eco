
Building interconnect mod

# Api

```lua
-- building with an interconnection
building_lib.register_building("buildings:water_pump", {
    -- other fields omitted
    interconnect = {
        groups = {
            water = true
        }
    }
})

local mapblock_pos = { x=0, y=0, z=0 }
local group = "water"
local network = building_lib_interconnect.get_network(mapblock_pos, group)
network = {
    ["(0,0,0)"] = true,
    ["(0,0,1)"] = true,
    ["(0,0,2)"] = true
}

-- (re-)scan manually
building_lib_interconnect.scan(mapblock_pos, group)

-- connect a region to the networks in cardinal directions
building_lib_interconnect.connect(mapblock_pos1, mapblock_pos2, group)

-- disconnect a region from the network
building_lib_interconnect.disconnect(mapblock_pos1, mapblock_pos2, group)

```

# License

* Code: `MIT`
* Textures: `CC-BY-SA-3.0`