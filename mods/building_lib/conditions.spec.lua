
building_lib.register_condition("success", {
    can_build = function() return true end
})

building_lib.register_condition("failure", {
    can_build = function() return false, "no success" end
})

local test_map = {
    ["(0,1,0)"] = 1,
    ["(0,2,0)"] = 2
}

building_lib.register_condition("test_map", {
    can_build = function(mapblock_pos, flag_value)
        return test_map[minetest.pos_to_string(mapblock_pos)] == flag_value
    end
})

local function run_conditions(condition_groups)
    local mapblock_pos1 = {x = 0, y = 0, z = 0}
    local mapblock_pos2 = vector.add(mapblock_pos1, 2)
    return building_lib.check_condition_groups(mapblock_pos1, mapblock_pos2, condition_groups)
end

mtt.register("check_conditions", function(callback)

    -- all match
    local success, msg = run_conditions({
        {["*"] = { success = true }}
    })
    assert(success)
    assert(not msg)

    -- none match
    success, msg = run_conditions({
        {["*"] = { failure = true }}
    })
    assert(not success)
    assert(msg)

    -- single match
    success, msg = run_conditions({
        {["(0,1,0)"] = { test_map = 1 }}
    })
    assert(success)
    assert(not msg)

    -- miss
    success, msg = run_conditions({
        {["(0,1,0)"] = { test_map = 2 }}
    })
    assert(not success)
    assert(msg)

    -- miss and match
    success, msg = run_conditions({
        {["(0,1,0)"] = { test_map = 2 }},
        {["(0,2,0)"] = { test_map = 2 }}
    })
    assert(success)
    assert(not msg)

    callback()
end)
