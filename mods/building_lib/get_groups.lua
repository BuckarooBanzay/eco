
function building_lib.get_groups(mapblock_pos)
    local building_def = building_lib.get_building_at_pos(mapblock_pos)
    if not building_def then
        return {}
    else
        return building_def.groups or {}
    end
end