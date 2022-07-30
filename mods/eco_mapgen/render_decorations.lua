
function eco_mapgen.render_decorations(mapblock_pos)
    local biome_data = eco_mapgen.get_biome_data(mapblock_pos)
    local mapblock_pos_below = vector.add(mapblock_pos, {x=0,y=-1,z=0})
    local slope_info_below = eco_mapgen.get_slope_info(mapblock_pos_below)

    if biome_data.height == mapblock_pos.y - 1 and slope_info_below.type == "full" then
        -- full block beneath, render on-top decorations
        print("would decorate: " .. minetest.pos_to_string(mapblock_pos))
    end
end