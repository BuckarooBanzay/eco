
building_lib.register_on("placed", function(e)
    local ic = e.building_def.interconnect
    if not ic then
        return
    end

    local entry = building_lib.store:get(e.mapblock_pos) or {}
    local ic_entry = entry.interconnect or {}

    for connection_type, value in pairs(ic.consumer or {}) do
    end

    for connection_type in pairs(ic.connects or {}) do
    end

    for connection_type, value in pairs(ic.producer or {}) do
    end
end)

building_lib.register_on("replaced", function()
    -- TODO
end)

building_lib.register_on("removed", function()
    -- TODO
end)