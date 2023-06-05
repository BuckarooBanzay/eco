
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

    local network = building_lib_interconnect.create_network("water")
    assert(network.id)

    building_lib_interconnect.network_add_node(network, {x=1, y=2, z=3})
    building_lib_interconnect.network_add_node(network, {x=1, y=3, z=3})
    building_lib_interconnect.network_add_connection(network, {x=5, y=0, z=0})
    building_lib_interconnect.set_network(network)

    has_network({x=1, y=2, z=3}, network.id, true)
    has_network({x=1, y=3, z=3}, network.id, true)
    has_network({x=5, y=0, z=0}, network.id, true)

    building_lib_interconnect.network_remove_node(network, {x=1, y=2, z=3})
    building_lib_interconnect.set_network(network)

    has_network({x=1, y=2, z=3}, network.id, false)

    building_lib_interconnect.remove_network(network)

    has_network({x=1, y=3, z=3}, network.id, false)
    has_network({x=5, y=0, z=0}, network.id, false)

    callback()
end)