
building_lib_influence = {
    store = mapblock_lib.create_data_storage(minetest.get_mod_storage())
}

-- one superblock consists of 10^3 mapblocks
local function get_superblock_pos(mapblock_pos)
    return vector.floor( vector.divide(mapblock_pos, 10))
end

local function apply_box(p1, p2, fn)
    p1, p2 = mapblock_lib.sort_pos(p1, p2)
    assert(p2.x-p1.x >= 2, "box x side min-size")
    assert(p2.y-p1.y >= 2, "box y side min-size")
    assert(p2.z-p1.z >= 2, "box z side min-size")

    -- bottom and top (outer)
    for x=p1.x,p2.x do
        for z=p1.z,p2.z do
            fn({x=x, y=p1.y, z=z})
            fn({x=x, y=p2.y, z=z})
        end
    end
    -- z+ and z- sides (outer)
    for z=p1.z,p2.z do
        for y=p1.y+1,p2.y-1 do
            fn({x=p1.x, y=y, z=z})
            fn({x=p2.x, y=y, z=z})
        end
    end
    -- x+ and x- sides (outer)
    for x=p1.x,p2.x do
        for y=p1.y+1,p2.y-1 do
            fn({x=x, y=y, z=p1.z})
            fn({x=x, y=y, z=p2.z})
        end
    end
end

local function add_influence(superblock_pos, name, value)
    local groups = building_lib_influence.store:get(superblock_pos)
    if not groups then
        groups = {}
    end
    groups[name] = groups[name] or 0
    groups[name] = groups[name] + value
    building_lib_influence.store:set(superblock_pos, groups)
end

local function apply_influence(superblock_pos, name, entry, factor)
    -- defaults
    entry.value = entry.value or 1
    entry.reduction = entry.reduction or 1

    -- origin superblock
    add_influence(superblock_pos, name, entry.value*factor)

    -- distribute up to 10 superblocks away
    for distance=1,9 do
        -- calculate influence at this distance
        local influence = entry.value - (distance * entry.reduction)
        if influence < 0 then
            -- don't go further if the value is below zero
            break
        end

        -- calculate box corners
        local superblock_pos1 = vector.subtract(superblock_pos, distance)
        local superblock_pos2 = vector.add(superblock_pos, distance)

        -- apply influence value on box sides
        apply_box(superblock_pos1, superblock_pos2, function(p)
            add_influence(p, name, influence*factor)
        end)
    end
end

local function apply_influence_groups(mapblock_pos, groups, factor)
    if not groups then
        return
    end
    local superblock_pos = get_superblock_pos(mapblock_pos)
    for name, entry in pairs(groups) do
        apply_influence(superblock_pos, name, entry, factor)
    end
end

building_lib.register_on("placed", function(e)
    apply_influence_groups(e.mapblock_pos, e.building_def.influence, 1)
end)

building_lib.register_on("replaced", function(e)
    apply_influence_groups(e.mapblock_pos, e.old_building_def.influence, -1)
    apply_influence_groups(e.mapblock_pos, e.building_def.influence, 1)
end)

building_lib.register_on("placed_mapgen", function(e)
    apply_influence_groups(e.mapblock_pos, e.building_def.influence, 1)
end)

building_lib.register_on("removed", function(e)
    local building_name = e.building_info.name
    local building_def = building_lib.get_building(building_name)
    if not building_def then
        return
    end
    apply_influence_groups(e.mapblock_pos, building_def.influence, -1)
end)

function building_lib_influence.get_groups(mapblock_pos)
    local superblock_pos = get_superblock_pos(mapblock_pos)
    return building_lib_influence.store:get(superblock_pos) or {}
end

function building_lib_influence.get(mapblock_pos, name)
    local superblock_pos = get_superblock_pos(mapblock_pos)
    return building_lib_influence.get_groups(superblock_pos)[name] or 0
end

function building_lib_influence.clear(mapblock_pos)
    local superblock_pos = get_superblock_pos(mapblock_pos)
    building_lib_influence.store:set(superblock_pos)
end

minetest.register_chatcommand("influence_info", {
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local ppos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(ppos)
        local superblock_pos = get_superblock_pos(mapblock_pos)
        local data = building_lib_influence.store:get(superblock_pos)
        return true, "Influence-data for mapblock " .. minetest.pos_to_string(mapblock_pos) ..
            " (Superblock: " .. minetest.pos_to_string(superblock_pos) .. "): " .. dump(data)
    end
})

if minetest.get_modpath("mtt") and mtt.enabled then
    local MP = minetest.get_modpath("building_lib_influence")
    dofile(MP .. "/mtt.lua")
end