
local function has_network(mapblock_pos, network_id, state)
    local networks = building_lib_interconnect.get_networks_at_pos(mapblock_pos)
    local found = false
    for _, network in pairs(networks) do
        if network.id == network_id then
            found = true
            break
        end
    end
    assert(found == state)
end

mtt.register("interconnect:store", function(callback)

    -- create network

    local network = building_lib_interconnect.create_network("water")
    assert(network.id)

    -- add links and connection

    building_lib_interconnect.network_add_link(network, {x=1, y=2, z=3})
    building_lib_interconnect.network_add_link(network, {x=1, y=3, z=3})
    building_lib_interconnect.network_add_connection(network, {x=5, y=0, z=0})
    building_lib_interconnect.set_network(network)

    has_network({x=1, y=2, z=3}, network.id, true)
    has_network({x=1, y=3, z=3}, network.id, true)
    has_network({x=5, y=0, z=0}, network.id, true)
    assert(building_lib_interconnect.get_network_at_pos({x=1, y=2, z=3}, "water"))

    -- remove link

    building_lib_interconnect.network_remove_link(network, {x=1, y=2, z=3})
    building_lib_interconnect.set_network(network)

    has_network({x=1, y=2, z=3}, network.id, false)

    -- merge

    local network2 = building_lib_interconnect.create_network("water")
    building_lib_interconnect.network_add_link(network2, {x=10, y=2, z=3})
    building_lib_interconnect.set_network(network2)
    assert(network2.id ~= network.id)

    building_lib_interconnect.merge_networks(network, network2)
    network2 = building_lib_interconnect.get_network_at_pos({x=10, y=2, z=3}, "water")
    assert(network2.id == network.id)

    -- delete all
    building_lib_interconnect.remove_network(network)

    has_network({x=1, y=3, z=3}, network.id, false)
    has_network({x=5, y=0, z=0}, network.id, false)
    assert(not building_lib_interconnect.get_network_at_pos({x=1, y=2, z=3}, "water"))


    callback()
end)