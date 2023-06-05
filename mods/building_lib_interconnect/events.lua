
building_lib.register_on("placed", function(e)
    -- TODO: check if building has connections
    -- TODO: check each connection for networks
    -- TODO: merge networks if needed
end)

building_lib.register_on("replaced", function()
    -- TODO: remove -> place
end)

building_lib.register_on("removed", function()
    -- TODO: check if building has connections
    -- TODO: check if the connections are still connected
    -- TODO: split if needed
end)