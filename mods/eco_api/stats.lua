
local function update_cityblock_stats(mapblock_pos, stats, factor)
    if not stats then
        return
    end

    -- load data or create defaults
    local cityblock = eco_api.get_cityblock(mapblock_pos) or {}
    cityblock.stats = cityblock.stats or {}

    -- update stats with factor
    for key, value in pairs(stats) do
        -- default to 0
        local current_value = cityblock.stats[key] or 0

        -- add with factor
        cityblock.stats[key] = current_value + (factor * value)
    end

    eco_api.set_cityblock(mapblock_pos, cityblock)
end

building_lib.register_on("placed_mapgen", function(e)
    update_cityblock_stats(e.mapblock_pos, e.building_def.stats, 1)
end)

building_lib.register_on("placed", function(e)
    update_cityblock_stats(e.mapblock_pos, e.building_def.stats, 1)
end)

building_lib.register_on("replaced", function(e)
    update_cityblock_stats(e.mapblock_pos, e.old_building_def.stats, -1)
    update_cityblock_stats(e.mapblock_pos, e.building_def.stats, 1)
end)

building_lib.register_on("removed", function(e)
    update_cityblock_stats(e.mapblock_pos, e.old_building_def.stats, -1)
end)
