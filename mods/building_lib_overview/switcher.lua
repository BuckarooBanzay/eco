
minetest.register_tool("building_lib_overview:switcher", {
    description = "Overview switcher",
    inventory_image = "building_lib_overview_switcher.png^[colorize:#0000ff",
    stack_max = 1,
    range = 0,
    on_use = function(_, player)
        local ppos = player:get_pos()
        if building_lib_overview.is_in_overview(ppos) then
            -- transfer to building world
            local build_pos = building_lib_overview.overview_to_node_pos(ppos)
            player:set_pos(build_pos)
        else
            -- transfer to overview
            local mapblock_pos =  mapblock_lib.get_mapblock(ppos)
            local o_pos = building_lib_overview.mapblock_pos_to_overview(mapblock_pos)
            player:set_pos(o_pos)
        end
    end
})