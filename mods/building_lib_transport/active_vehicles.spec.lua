

mtt.register("active vehicle", function(callback)
    local active_vehicle = building_lib_transport.place_vehicle("testcar", {x=0,y=0,z=0}, "left")

    assert(active_vehicle)
    assert(building_lib_transport.get_active_vehicle({x=0,y=0,z=0}, "left") == active_vehicle)

    building_lib_transport.remove_active_vehicle(active_vehicle)

    callback()
end)