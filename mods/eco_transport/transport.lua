
-- TODO: transport/move functions

-- returns the node-length of all points/segments
function eco_transport.get_route_length(building_name, route_name)
end

-- returns the absolute position of the entity/item on the map
-- for displaying as entities in active/visible blocks
function eco_transport.get_position(entry)
    return {} -- TODO (maybe return direction too)
end

-- all currently moving items on the map
-- serialized periodically / deserialized on start
local entries = {
    -- building_pos/routename key for lookup
    ["(0,0,0)/main"] = {
        type = "container-3",
        data = {
            inventory = "eco:stone 99"
        },
        -- building origin in mapblocks
        building_pos = { x=0, y=0, z=0 },
        -- current route
        route = {
            name = "main",
            length = 12
        },
        -- number of nodes into route
        position = 10,
        -- entry valid until (no processing/movement occurs until then)
        valid_until = 1234
    }
}

local function move_entry(dtime, entry)
    local velocity = 1 -- nodes/second
    local movement = velocity * dtime
    entry.position = entry.position + movement
    if entry.position > entry.route.length then
        -- moved beyond current route

        -- movement length into next route(s)
        local remaining_movement = entry.position - entry.route.length

        -- TODO: find next route
    end
end

local function move_entries(dtime)
    local now = os.time()
    for _, entry in pairs(entries) do
        if entry.valid_until < now then
            -- entry-position not valid anymore, calculate new position/route
            move_entry(dtime, entry)
        end
    end
end

move_entries(0.1)