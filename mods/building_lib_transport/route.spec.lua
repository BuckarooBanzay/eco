
mtt.register("route", function(callback)
    building_lib_transport.create_route("my_route", {
        -- TODO
    })

    local route = building_lib_transport.get_route("my_route")
    assert(route)

    callback();
end)