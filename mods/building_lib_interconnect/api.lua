

-- group-name => { network-id => { {x,y,z}, ... } }
local network_groups = {}

local function get_network_group(group)
    local network_group = network_groups[group]
    if not network_group then
        network_group = {}
        network_groups[group] = network_group
    end
    return network_group
end

function building_lib_interconnect.get_network(mapblock_pos, group)
    local network_group = get_network_group(group)
    local pos_str = minetest.pos_to_string(mapblock_pos)
    for _, network in pairs(network_group) do
        if network[pos_str] then
            return network
        end
    end
end

function building_lib_interconnect.add_to_network(mapblock_pos, group)
    local network = building_lib_interconnect.get_network(mapblock_pos, group)
    local pos_str = minetest.pos_to_string(mapblock_pos)
    if not network then
        local network_group = get_network_group(group)
        network = { [pos_str] = true }
        network_group[math.random(10000)] = network
    end
    return network
end

function building_lib_interconnect.remove_from_network(mapblock_pos, group)
    local network = building_lib_interconnect.get_network(mapblock_pos, group)
    local pos_str = minetest.pos_to_string(mapblock_pos)
    if network then
        network[pos_str] = nil
    end
    return network
end
