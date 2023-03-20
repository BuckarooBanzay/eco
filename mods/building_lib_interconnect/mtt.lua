
mtt.register("interconnect", function(callback)
    local group = "testgroup"

    local network = building_lib_interconnect.get_network({x=0,y=0,z=0}, group)
    assert(not network)

    network = building_lib_interconnect.add_to_network({x=0,y=0,z=0}, group)
    assert(network)

    network = building_lib_interconnect.get_network({x=0,y=0,z=0}, group)
    assert(network)

    building_lib_interconnect.remove_from_network({x=0,y=0,z=0}, group)

    network = building_lib_interconnect.get_network({x=0,y=0,z=0}, group)
    assert(not network)

    callback()
end)