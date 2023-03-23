

building_lib.register_building("test_ic:water_pump", {
    placement = "dummy",
    interconnect = {
        producer = {
            water = 200
        }
    }
})

building_lib.register_building("test_ic:water_pipe", {
    placement = "dummy",
    interconnect = {
        connects = {
            water = true
        }
    }
})

building_lib.register_building("test_ic:water_distribution", {
    placement = "dummy",
    interconnect = {
        consumer = {
            water = 50
        }
    }
})

mtt.register("interconnect", function(callback)
    -- clear store
    building_lib.store:clear()

    local playername = "singleplayer"

    assert(building_lib.build({x=0,y=0,z=0}, playername, "test_ic:water_pump"))
    assert(building_lib.build({x=1,y=0,z=0}, playername, "test_ic:water_pipe"))
    assert(building_lib.build({x=2,y=0,z=0}, playername, "test_ic:water_pipe"))
    assert(building_lib.build({x=3,y=0,z=0}, playername, "test_ic:water_pipe"))
    assert(building_lib.build({x=4,y=0,z=0}, playername, "test_ic:water_distribution"))

    callback()
end)