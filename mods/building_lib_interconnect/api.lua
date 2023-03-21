

--[[
group-name => {
    network-id => {
        ["{x,y,z}"] = true",
        ...
    }
}
--]]
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

function building_lib_interconnect.scan(mapblock_pos, group)
    local building_def = building_lib.get_building_def_at(mapblock_pos)
    if not building_def or not building_def.interconnect or not building_def.interconnect[group] then
        return
    end

    -- TODO
end
