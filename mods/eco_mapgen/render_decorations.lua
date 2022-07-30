
function eco_mapgen.prepare_decoration_list(biome_name)
    local decorations = eco_mapgen.get_decorations(biome_name)
    -- find out max chance value
    local max_chance_value = 1
    for _, decoration in ipairs(decorations) do
        max_chance_value = max_chance_value + decoration.chance
    end
    -- populate chance-list
    local chance_list = {}
    for _, decoration in ipairs(decorations) do
        local inv_chance = math.floor( (max_chance_value / decoration.chance) + 0.5 )
        for _=1,inv_chance do
            table.insert(chance_list, decoration)
        end
    end

    return chance_list, max_chance_value
end

function eco_mapgen.select_decoration(biome_name)
    local chance_list, max_chance_value = eco_mapgen.prepare_decoration_list(biome_name)
    return chance_list[math.random(max_chance_value)]
end

local angles = {0,90,180,270}

function eco_mapgen.render_decorations(mapblock_pos)
    local biome_data = eco_mapgen.get_biome_data(mapblock_pos)
    local mapblock_pos_below = vector.add(mapblock_pos, {x=0,y=-1,z=0})
    local slope_info_below = eco_mapgen.get_slope_info(mapblock_pos_below)

    if biome_data.height == mapblock_pos.y - 1 and slope_info_below.type == "full" then
        -- full block beneath, render on-top decorations
        local biome = eco_mapgen.get_biome(mapblock_pos)

        local decoration = eco_mapgen.select_decoration(biome.name)
        if decoration then
            -- select and rotate
            local catalog = mapblock_lib.get_catalog(decoration.catalog)
            catalog:deserialize(decoration.select(mapblock_pos), mapblock_pos, {
                transform = {
                    rotate = {
                        axis = "y",
                        angle = angles[math.random(#angles)]
                    }
                }
            })
        end
    end
end