
Building interconnect mod

# Api

```lua
-- building with an interconnection
building_lib.register_building("buildings:water_line", {
    -- other fields omitted
    interconnect = {
        groups = {
            water = true
        }
    }
})

local mapblock_pos = { x=0, y=0, z=0 }
local network = building_lib_interconnect.get_network(mapblock_pos, "water")
network = {
    ["(0,0,0)"] = true,
    ["(0,0,1)"] = true,
    ["(0,0,2)"] = true
}

building_lib_interconnect.add_to_network(mapblock_pos, "water")
building_lib_interconnect.remove_from_network(mapblock_pos, "water")

```

# License

* Code: `MIT`
* Textures: `CC-BY-SA-3.0`