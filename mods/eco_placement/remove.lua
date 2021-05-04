minetest.register_craftitem("eco_placement:remove", {
    description = "Remove tool",
    inventory_image = "eco_placement_inv_remove.png",
    on_use = function(_, player)
        local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)
        if mapblock_pos then
            mapblock_lib.display_mapblock(mapblock_pos, "Remove", 2)
        end
    end,
    on_secondary_use = function(_, player)
        local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)
        if mapblock_pos then
            eco_mapgen.restore_mapblock(mapblock_pos)
        end
    end
})
