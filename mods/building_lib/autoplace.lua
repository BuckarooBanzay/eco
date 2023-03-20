
function building_lib.can_autoplace(mapblock_pos, _, autoplacer_name)
    local autoplacer = building_lib.get_autoplacer(autoplacer_name)
    if not autoplacer then
        return false, "autoplacer not found: '" .. autoplacer_name .. "'"
    end

    local fallback_building_name
    for _, building_condition in ipairs(autoplacer.buildings) do
        if building_condition.fallback then
            fallback_building_name = building_condition.name
        end

        for _, rotation in ipairs(building_condition.rotations or {0}) do
            local rotated_condition_group = building_lib.rotate_condition_group(building_condition.conditions, rotation)
            local success = building_lib.check_condition_group(mapblock_pos, mapblock_pos, rotated_condition_group)
            if success then
                return true, building_condition.name, rotation
            end
        end
    end

    if fallback_building_name then
        return true, fallback_building_name, 0
    else
        return false, "no conditions matched"
    end
end

local default_propagation_dirs = {
    {x=1, y=0, z=0},
    {x=-1, y=0, z=0},
    {x=0, y=0, z=1},
    {x=0, y=0, z=-1},
    {x=1, y=1, z=0},
    {x=-1, y=1, z=0},
    {x=0, y=1, z=1},
    {x=0, y=1, z=-1},
}

function building_lib.autoplace(mapblock_pos, playername, autoplacer_name, enable_propagation)
    local success, building_name, rotation = building_lib.can_autoplace(mapblock_pos, playername, autoplacer_name)
    if not success then
        return false, building_name
    end

    local err
    success, err = building_lib.build(mapblock_pos, playername, building_name, rotation)
    if not success then
        return success, err
    end

    local autoplacer = building_lib.get_autoplacer(autoplacer_name)
    if enable_propagation and autoplacer.propagate then
        -- propagate changes
        for _, dir in ipairs(autoplacer.propagation_dirs or default_propagation_dirs) do
            local offset_mapblock_pos = vector.add(mapblock_pos, dir)
            success = building_lib.check_condition_table(autoplacer.propagate, offset_mapblock_pos)
            if success then
                -- selector matches, propagate autobuild
                building_lib.autoplace(offset_mapblock_pos, playername, autoplacer_name, false)
            end
        end
    end

    return true
end
