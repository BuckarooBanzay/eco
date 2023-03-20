
mtt.register("overview", function(callback)

    local node_pos = building_lib_overview.mapblock_pos_to_overview({x=10, y=30, z=40})
    assert(node_pos.x == 10)
    assert(node_pos.y == 30 + 25000)
    assert(node_pos.z == 40)

    local mapblock_pos = building_lib_overview.overview_to_mapblock_pos(node_pos)
    assert(mapblock_pos.x == 10)
    assert(mapblock_pos.y == 30)
    assert(mapblock_pos.z == 40)

    assert(not building_lib_overview.is_in_overview({x=10, y=20, z=30}))
    assert(building_lib_overview.is_in_overview({x=10, y=25001, z=30}))

    node_pos = building_lib_overview.overview_to_node_pos({x=10, y=25001, z=60})
    assert(node_pos.x > 16*10)
    assert(node_pos.x < 16*11)
    assert(node_pos.y > 16)
    assert(node_pos.y < 32)
    assert(node_pos.z > 16*60)
    assert(node_pos.z < 16*61)

    callback()
end)