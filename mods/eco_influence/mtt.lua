building_lib.register_placement("dummy", {
    check = function() return true end,
    get_size = function() return {x=1,y=1,z=1} end,
    place = function(_, _, _, _, callback) callback() end
})

building_lib.register_building("eco_influence:my_building", {
	placement = "dummy",
    influence = {
        noise = 4
    }
})

mtt.register("influence", function(callback)
    local groups = eco_influence.get_groups({ x=0, y=0, z=0})
    assert(groups)

    local noise = eco_influence.get({ x=0, y=0, z=0 }, "noise")
    assert(noise == 0)

    local success, err = building_lib.build({ x=0, y=0, z=0 }, "singleplayer", "eco_influence:my_building", 0)
    assert(success)
    assert(not err)

    groups = eco_influence.get_groups({ x=0, y=0, z=0})
    assert(groups)
    assert(groups.noise == 4)

    assert(eco_influence.get({ x=0, y=0, z=0 }, "noise") == 4)
    assert(eco_influence.get({ x=0, y=1, z=0 }, "noise") == 3)
    assert(eco_influence.get({ x=0, y=1, z=1 }, "noise") == 3)
    assert(eco_influence.get({ x=0, y=2, z=0 }, "noise") == 2)
    assert(eco_influence.get({ x=0, y=3, z=0 }, "noise") == 1)
    assert(eco_influence.get({ x=0, y=4, z=0 }, "noise") == 0)

    callback()
end)