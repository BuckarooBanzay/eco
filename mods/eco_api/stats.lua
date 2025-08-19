
local function update_superblock_stats(mapblock_pos, stats, factor)
    if not stats then
        return
    end

    -- load data or create defaults
    local superblock = eco_api.get_superblock(mapblock_pos) or {}
    superblock.stats = superblock.stats or {}

    -- update stats with factor
    for key, value in pairs(stats) do
        -- default to 0
        local current_value = superblock.stats[key] or 0

        -- add with factor
        superblock.stats[key] = current_value + (factor * value)
    end

    eco_api.set_superblock(mapblock_pos, superblock)
end

building_lib.register_on("placed_mapgen", function(e)
    update_superblock_stats(e.mapblock_pos, e.building_def.stats, 1)
end)

building_lib.register_on("placed", function(e)
    update_superblock_stats(e.mapblock_pos, e.building_def.stats, 1)
end)

building_lib.register_on("replaced", function(e)
    update_superblock_stats(e.mapblock_pos, e.old_building_def.stats, -1)
    update_superblock_stats(e.mapblock_pos, e.building_def.stats, 1)
end)

building_lib.register_on("removed", function(e)
    update_superblock_stats(e.mapblock_pos, e.old_building_def.stats, -1)
end)
