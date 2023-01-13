
mtt.register("vehicle_store", function(callback)
    local mapblock_pos = {x=10,y=10,z=10}
    building_lib_transport.set_mapblock_vehicles(mapblock_pos, {
        left = { name = "x" }
    })

    local vehicles = building_lib_transport.get_mapblock_vehicles(mapblock_pos)
    assert(vehicles.left.name == "x")

    callback()
end)