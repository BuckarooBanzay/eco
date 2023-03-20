
mtt.register("events", function(callback)

    local success = false

    building_lib.register_on("my_event", function(x,y)
        if x == 1 and y == 2 then
            success = true
        end
    end)

    building_lib.fire_event("my_event", 1, 2)

    assert(success)
    callback()
end)