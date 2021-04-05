require("mineunit")

mineunit("core")
mineunit("player")
mineunit("default/functions")

sourcefile("init")

building_lib.register_condition({
    name = "success",
    can_build = function() return true end
})

building_lib.register_condition({
    name = "failure",
    can_build = function() return false, "no success" end
})

building_lib.register_placement({
    name = "dummy",
    check = function() return true end,
    place = function() end
})

local function run_conditions(conditions)
    local mapblock_pos = {x = 0, y = 0, z = 0}
    return building_lib.can_build(mapblock_pos, {
        name = "something:test1",
        placement = "dummy",
        conditions = conditions
    })
end

describe("building_lib.can_build", function()
    it("simple success", function()
        local success, msg = run_conditions({success = true})

        assert.equals(true, success)
        assert.is_nil(msg)
    end)

    it("simple failure", function()
        local success, msg = run_conditions({failure = true})

        assert.equals(false, success)
        assert.not_nil(msg)
    end)

    it("map mix 1", function()
        local success, msg = run_conditions({failure = true, success = true})

        assert.equals(true, success)
        assert.is_nil(msg)
    end)

    it("array mix 1", function()
        local success, msg = run_conditions({{failure = true, success = true}})

        assert.equals(false, success)
        assert.not_nil(msg)
    end)

    it("array mix 2", function()
        local success, msg = run_conditions(
                                 {
                {failure = true, success = true}, {success = true}
            })

        assert.equals(true, success)
        assert.is_nil(msg)
    end)

    it("array mix 3", function()
        local success, msg = run_conditions(
                                 {
                {failure = true, success = true}, {failure = true}
            })

        assert.equals(false, success)
        assert.not_nil(msg)
    end)

end)
