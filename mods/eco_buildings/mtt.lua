-- register test building defs
local MP = minetest.get_modpath("eco_buildings")

-- a 1x1 building with connections
building_lib.register_building("simple_building", {
    placement = "simple",
    connections = {
        ["1,0,0"] = "conngroup"
    },
    catalog = MP .. "/schematics/foundation.zip"
})

-- connected placement, only 1x1 allowed
building_lib.register_building("connected_building", {
    placement = "connected",
    groups = {
        conngroup = true
    },
    tiles = {
        ["0,0,0"] = {
            default = true,
            rotations = {0},
            connections = {
                ["1,0,0"] = "conngroup",
                ["-1,0,0"] = "conngroup",
                ["0,0,1"] = "conngroup",
                ["0,0,-1"] = "conngroup"
            }
        },
        ["1,0,0"] = {
            rotations = {0,90,180,270},
            connections = {
                ["1,0,0"] = "conngroup"
            }
        }
    },
    catalog = MP .. "/schematics/foundation.zip"
})

mtt.register("select_tile", function(callback)
    local mapblock_pos1 = {x=0,y=0,z=0}
    local mapblock_pos2 = {x=1,y=0,z=0}

    local callback_count = 0
    local function progress()
        callback_count = callback_count + 1
        if callback_count == 3 then
            callback()
        end
    end

    local success, err = building_lib.do_build(
        mapblock_pos1,
        "simple_building",
        { rotation = 0 },
        progress
    )
    assert(success)
    assert(err == nil)

    success, err = building_lib.do_build(mapblock_pos2, "connected_building", {}, progress)
    assert(success)
    assert(err == nil)

    local mapblock_data = building_lib.store:get(mapblock_pos2)
    assert(mapblock_data.placement_options.rotation == 180)
    assert(mapblock_data.placement_options.tile_pos.x == 1)
    assert(mapblock_data.placement_options.tile_pos.y == 0)
    assert(mapblock_data.placement_options.tile_pos.z == 0)

    progress()
end)