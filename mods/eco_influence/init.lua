
eco_influence = {
    store = mapblock_lib.create_data_storage(minetest.get_mod_storage())
}

local function apply_cube(p1, p2, fn)
    p1, p2 = mapblock_lib.sort_pos(p1, p2)
    for x=p1.x,p2.x do
        for y=p1.y,p2.y do
            for z=p1.z,p2.z do
                fn({x=x,y=y,z=z})
            end
        end
    end
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

local function add_influence(pos, name, value)
    local groups = eco_influence.store:get(pos)
    if not groups then
        groups = {}
    end
    groups[name] = groups[name] or 0
    groups[name] = groups[name] + value
    eco_influence.store:set(pos, groups)
end

local function apply_influence(mapblock_pos1, mapblock_pos2, name, value, factor)
    -- clamp max value to 10
    value = math.min(10, value)

    -- inner box
    apply_cube(mapblock_pos1, mapblock_pos2, function(mapblock_pos)
        add_influence(mapblock_pos, name, value*factor)
    end)

    for influence=value-1,1,-1 do
        -- increase box size
        mapblock_pos1 = vector.subtract(mapblock_pos1, 1)
        mapblock_pos2 = vector.add(mapblock_pos2, 1)
        apply_box(mapblock_pos1, mapblock_pos2, function(mapblock_pos)
            add_influence(mapblock_pos, name, influence*factor)
        end)
    end
end

local function apply_influence_groups(mapblock_pos, size, groups, factor)
    if not groups then
        return
    end
    local mapblock_pos2 = vector.add(mapblock_pos, vector.subtract(size,1))
    for name, value in pairs(groups) do
        apply_influence(mapblock_pos, mapblock_pos2, name, value, factor)
    end
end

building_lib.register_on("placed", function(mapblock_pos, _, building_def, _, size)
    apply_influence_groups(mapblock_pos, size, building_def.influence, 1)
end)

building_lib.register_on("replaced", function(mapblock_pos, _, old_building_def, new_building_def, _, size)
    apply_influence_groups(mapblock_pos, size, old_building_def.influence, -1)
    apply_influence_groups(mapblock_pos, size, new_building_def.influence, 1)
end)

building_lib.register_on("placed_mapgen", function(mapblock_pos, building_def)
    apply_influence_groups(mapblock_pos, {x=1,y=1,z=1}, building_def.influence, 1)
end)

building_lib.register_on("removed", function(mapblock_pos, _, building_info)
    local building_name = building_info.name
    local building_def = building_lib.get_building(building_name)
    if not building_def then
        return
    end
    local size = building_info.size
    apply_influence_groups(mapblock_pos, size, building_def.influence, -1)
end)

function eco_influence.get_groups(mapblock_pos)
    return eco_influence.store:get(mapblock_pos) or {}
end

function eco_influence.get(mapblock_pos, name)
    return eco_influence.get_groups(mapblock_pos)[name] or 0
end

function eco_influence.clear(mapblock_pos1, mapblock_pos2)
    mapblock_pos2 = mapblock_pos2 or mapblock_pos1
    apply_cube(mapblock_pos1, mapblock_pos2, function(mapblock_pos)
        eco_influence.store:set(mapblock_pos)
    end)
end

minetest.register_chatcommand("influence_info", {
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local ppos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(ppos)
        local data = eco_influence.store:get(mapblock_pos)
        return true, "Influecne-data for mapblock " .. minetest.pos_to_string(mapblock_pos) .. ": " .. dump(data)
    end
})

if minetest.get_modpath("mtt") and mtt.enabled then
    local MP = minetest.get_modpath("eco_influence")
    dofile(MP .. "/mtt.lua")
end