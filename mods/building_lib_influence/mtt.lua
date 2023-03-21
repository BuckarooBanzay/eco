
building_lib.register_building("building_lib_influence:my_building", {
	placement = "dummy",
    influence = {
        noise = 4
    }
})

mtt.register("building_lib_influence", function(callback)
    -- clear store
    building_lib.store:clear()

    local groups = building_lib_influence.get_groups({ x=0, y=0, z=0})
    assert(groups)

    local noise = building_lib_influence.get({ x=0, y=0, z=0 }, "noise")
    assert(noise == 0)

    local success, err = building_lib.build({ x=0, y=0, z=0 }, "singleplayer", "building_lib_influence:my_building", 0)
    assert(success)
    assert(not err)

    groups = building_lib_influence.get_groups({ x=0, y=0, z=0})
    assert(groups)
    assert(groups.noise == 4)

    assert(building_lib_influence.get({ x=0, y=0, z=0 }, "noise") == 4)
    assert(building_lib_influence.get({ x=0, y=1, z=0 }, "noise") == 3)
    assert(building_lib_influence.get({ x=0, y=1, z=1 }, "noise") == 3)
    assert(building_lib_influence.get({ x=0, y=2, z=0 }, "noise") == 2)
    assert(building_lib_influence.get({ x=0, y=3, z=0 }, "noise") == 1)
    assert(building_lib_influence.get({ x=0, y=4, z=0 }, "noise") == 0)

    success, err = building_lib.remove({ x=0, y=0, z=0 })
    assert(not err)
    assert(success)

    assert(building_lib_influence.get({ x=0, y=0, z=0 }, "noise") == 0)
    assert(building_lib_influence.get({ x=0, y=1, z=0 }, "noise") == 0)
    assert(building_lib_influence.get({ x=0, y=2, z=0 }, "noise") == 0)

    callback()
end)