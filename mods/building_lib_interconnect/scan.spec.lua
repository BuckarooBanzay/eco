

building_lib.register_building("test_ic:water_pump", {
    placement = "dummy",
    interconnect = {
        connects_to = {
            water = {
                { x=1, y=0, z=0 }
            }
        }
    }
})

building_lib.register_building("test_ic:water_pipe", {
    placement = "dummy",
    interconnect = {
        connects = {
            water = {
                { x=1, y=0, z=0 },
                { x=-1, y=0, z=0 }
            }
        }
    }
})

building_lib.register_building("test_ic:water_sink", {
    placement = "dummy",
    interconnect = {
        connects_to = {
            water = {
                { x=-1, y=0, z=0 }
            }
        }
    }
})

mtt.register("interconnect:scan", function(callback)
    -- clear store
    building_lib.store:clear()

    local playername = "singleplayer"

    assert(building_lib.build({x=0,y=0,z=0}, playername, "test_ic:water_pump"))
    assert(building_lib.build({x=1,y=0,z=0}, playername, "test_ic:water_pipe"))
    assert(building_lib.build({x=1,y=0,z=1}, playername, "test_ic:water_sink", 90)) -- rotated and not connected
    assert(building_lib.build({x=2,y=0,z=0}, playername, "test_ic:water_pipe"))
    assert(building_lib.build({x=3,y=0,z=0}, playername, "test_ic:water_pipe"))
    assert(building_lib.build({x=3,y=0,z=1}, playername, "test_ic:water_sink")) -- not connected
    assert(building_lib.build({x=4,y=0,z=0}, playername, "test_ic:water_sink"))

    local pos_list = building_lib_interconnect.scan({x=1,y=0,z=0}, "water")
    assert(#pos_list == 2) -- 1 pump and 1 sink
    assert(vector.equals(pos_list[1], {x=4,y=0,z=0}))
    assert(vector.equals(pos_list[2], {x=0,y=0,z=0}))

    callback()
end)