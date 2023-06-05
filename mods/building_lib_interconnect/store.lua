
--[[
network-pos lookup:

local network = minetest.serialize({
    id = <uuid>,
    type = "water",
    connections = {
        -- list of connected building-origin-hashes (producers, consumers)
    },
    nodes = {
        -- list of node-mapblock-hashes that make up the network
    }
})
store:set_string("network_" .. id, network)
--]]
local store = minetest.get_mod_storage()

--[[
pos-network lookup
* pos_store:set({x=0,y=0,z=0}, { networks = {<uuid> = true, ...} })
--]]
local pos_store = mapblock_lib.create_data_storage(store)

function building_lib_interconnect.get_networks_at_pos(mapblock_pos)
    local entry = pos_store:get(mapblock_pos) or {}
    local networks = {}
    for network_id in pairs(entry.networks) do
        table.insert(networks, building_lib_interconnect.get_network(network_id))
    end
    return networks
end

function building_lib_interconnect.add_network_at_pos(mapblock_pos, network)
    local entry = pos_store:get(mapblock_pos) or {}
    entry.networks = entry.networks or {}
    entry.networks[network.id] = true
    pos_store:set(mapblock_pos, entry)
end

function building_lib_interconnect.remove_network_at_pos(mapblock_pos, network)
    local entry = pos_store:get(mapblock_pos) or {}
    entry.networks = entry.networks or {}
    entry.networks[network.id] = nil
    pos_store:set(mapblock_pos, entry)
end

function building_lib_interconnect.get_network(network_id)
    local data = store:get_string("network_" .. network_id)
    if data == "" then
        -- no such network
        return
    end
    return minetest.deserialize(data)
end

function building_lib_interconnect.set_network(network)
    store:set_string("network_" .. network.id, minetest.serialize(network))
end

function building_lib_interconnect.create_network(connection_type)
    return {
        id = building_lib_interconnect.new_uuid(),
        type = connection_type,
        connections = {},
        nodes = {}
    }
end

function building_lib_interconnect.remove_network(network)
    for hash in pairs(network.connections) do
        local mapblock_pos = minetest.get_position_from_hash(hash)
        building_lib_interconnect.remove_network_at_pos(mapblock_pos, network)
    end
    for hash in pairs(network.nodes) do
        local mapblock_pos = minetest.get_position_from_hash(hash)
        building_lib_interconnect.remove_network_at_pos(mapblock_pos, network)
    end
    store:set_string("network_" .. network.id, "")
end

-- helpers

function building_lib_interconnect.network_add_node(network, mapblock_pos)
    local hash = minetest.hash_node_position(mapblock_pos)
    network.nodes[hash] = true
    building_lib_interconnect.add_network_at_pos(mapblock_pos, network)
end

function building_lib_interconnect.network_remove_node(network, mapblock_pos)
    local hash = minetest.hash_node_position(mapblock_pos)
    network.nodes[hash] = nil
    building_lib_interconnect.remove_network_at_pos(mapblock_pos, network)
end

function building_lib_interconnect.network_add_connection(network, mapblock_pos)
    local hash = minetest.hash_node_position(mapblock_pos)
    network.connections[hash] = true
    building_lib_interconnect.add_network_at_pos(mapblock_pos, network)
end

function building_lib_interconnect.network_remove_connection(network, mapblock_pos)
    local hash = minetest.hash_node_position(mapblock_pos)
    network.connections[hash] = nil
    building_lib_interconnect.remove_network_at_pos(mapblock_pos, network)
end