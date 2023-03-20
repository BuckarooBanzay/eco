
building_lib.register_building("building_lib:dummy", {
	placement = "dummy"
})

-- building can only be placed over "dummy"
building_lib.register_building("building_lib:dummy_v2", {
	placement = "dummy",
    conditions = {
        {
            ["*"] = { name = "building_lib:dummy" }
        }
    }
})

mtt.register("build", function(callback)
    -- clear store
    building_lib.store:clear()

    local mapblock_pos = {x=0, y=0, z=0}
    local building_name = "building_lib:dummy"
    local rotation = 0
    local playername = "singleplayer"

    -- try to build
    local success, err = building_lib.can_build(mapblock_pos, playername, building_name, rotation)
    assert(not err)
    assert(success)

    -- build
    local callback_called = false
    success, err = building_lib.build(mapblock_pos, playername, building_name, rotation,
        function() callback_called = true end
    )
    assert(not err)
    assert(success)
    assert(callback_called)

    -- try to build again
    success, err = building_lib.can_build(mapblock_pos, playername, building_name, rotation)
    assert(err)
    assert(not success)

    -- check
    local info = building_lib.get_placed_building_info(mapblock_pos)
    assert(info.name == building_name)
    assert(info.rotation == rotation)
    assert(info.owner == playername)
    assert(info.size.x == 1)
    assert(info.size.y == 1)
    assert(info.size.z == 1)

    -- try to build over
    success, err = building_lib.can_build(mapblock_pos, playername, "building_lib:dummy_v2", rotation)
    assert(not err)
    assert(success)

    -- build over
    callback_called = false
    success, err = building_lib.build(mapblock_pos, playername, "building_lib:dummy_v2", rotation,
        function() callback_called = true end
    )
    assert(not err)
    assert(success)
    assert(callback_called)

    -- try to remove
    success, err = building_lib.can_remove(mapblock_pos)
    assert(not err)
    assert(success)

    -- remove
    success, err = building_lib.remove(mapblock_pos)
    assert(not err)
    assert(success)

    -- check
    info = building_lib.get_placed_building_info(mapblock_pos)
    assert(info == nil)

    callback()
end)

mtt.benchmark("build", function(callback, iterations)
    -- clear store
    building_lib.store:clear()

    local mapblock_pos = {x=0, y=0, z=0}
    local building_name = "building_lib:dummy"
    local rotation = 0
    local playername = "singleplayer"

    for _=1,iterations do
        -- build
        local callback_called = false
        local success, err = building_lib.build(mapblock_pos, playername, building_name, rotation,
            function() callback_called = true end
        )
        assert(not err)
        assert(success)
        assert(callback_called)

        -- remove
        success, err = building_lib.remove(mapblock_pos)
        assert(not err)
        assert(success)
    end

    callback()
end)