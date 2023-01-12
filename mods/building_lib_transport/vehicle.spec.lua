
mtt.register("vehicle", function(callback)
    assert(building_lib_transport.get_vehicle("testcar"))
    callback()
end)