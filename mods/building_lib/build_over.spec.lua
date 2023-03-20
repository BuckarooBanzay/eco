
building_lib.register_building("building_lib:dummy_base", {
	placement = "dummy",
    size = { x=3, y=1, z=1 }
})

-- building can only be placed over "dummy"
building_lib.register_building("building_lib:dummy_extension", {
	placement = "dummy",
    size = { x=3, y=1, z=1 },
    conditions = {
        {
            ["*"] = { name = "building_lib:dummy_base" }
        }
    }
})

mtt.register("build-over", function(callback)
    -- clear store
    building_lib.store:clear()

    local mapblock_pos = {x=0, y=0, z=0}
    local rotation = 0
    local playername = "singleplayer"

    -- build
    local callback_called = false
    local success, err = building_lib.build(mapblock_pos, playername, "building_lib:dummy_base", rotation,
        function() callback_called = true end
    )
    assert(not err)
    assert(success)
    assert(callback_called)

    -- build over (wrong angle)
    success, err = building_lib.build(mapblock_pos, playername, "building_lib:dummy_extension", 90)
    assert(err)
    assert(not success)

    -- build over (wrong angle 2)
    success, err = building_lib.build(mapblock_pos, playername, "building_lib:dummy_extension", 270)
    assert(err)
    assert(not success)

    -- build over (180° rotated)
    callback_called = false
    success, err = building_lib.build(mapblock_pos, playername, "building_lib:dummy_extension", 180,
        function() callback_called = true end
    )
    assert(not err)
    assert(success)
    assert(callback_called)

    callback()
end)
