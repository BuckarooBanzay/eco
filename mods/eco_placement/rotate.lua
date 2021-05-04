minetest.register_craftitem("eco_placement:rotate", {
    description = "Remove tool",
    inventory_image = "eco_placement_inv_rotate.png",
    on_use = function(_, player)
        local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)
        if mapblock_pos then
            mapblock_lib.display_mapblock(mapblock_pos, "Rotate CCW", 2)
        end
    end,
    on_secondary_use = function()
    end
})
