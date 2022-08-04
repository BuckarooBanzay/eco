
building_lib.register_condition("success", {
    can_build = function() return true end
})

building_lib.register_condition("failure", {
    can_build = function() return false, "no success" end
})

building_lib.register_placement("dummy", {
    check = function() return true end,
    get_size = function() return {x=1,y=1,z=1} end,
    place = function() end
})

local function run_conditions(conditions)
    local mapblock_pos = {x = 0, y = 0, z = 0}
    return building_lib.check_conditions(mapblock_pos, conditions, {
        name = "something:test1",
        placement = "dummy",
        conditions = conditions
    })
end

mtt.register("simple success", function(callback)
    local success, msg = run_conditions({success = true})

    assert(success)
    assert(msg == nil)
    callback()
end)

mtt.register("simple failure", function(callback)
    local success, msg = run_conditions({failure = true})

    assert(not success)
    assert(msg ~= nil)
    callback()
end)

mtt.register("map mix 1", function(callback)
    local success, msg = run_conditions({failure = true, success = true})

    assert(success)
    assert(msg == nil)
    callback()
end)

mtt.register("array mix 1", function(callback)
    local success, msg = run_conditions({{failure = true, success = true}})

    assert(not success)
    assert(msg ~= nil)
    callback()
end)

mtt.register("array mix 2", function(callback)
    local success, msg = run_conditions({
        {failure = true, success = true}, {success = true}
    })

    assert(success)
    assert(msg == nil)
    callback()
end)

mtt.register("array mix 3", function(callback)
    local success, msg = run_conditions({
        {failure = true, success = true}, {failure = true}
    })

    assert(not success)
    assert(msg ~= nil)
    callback()
end)

