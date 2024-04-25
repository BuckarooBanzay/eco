local MP = minetest.get_modpath("eco_transport")

local conditions = {
    {
        -- flat surface
        ["*"] = { empty = true },
        ["underground"] = { group = "flat_surface"}
    }
}

-- producer building
building_lib.register_building("eco_transport:producer", {
	catalog = MP .. "/schematics/conveyor_straight.zip",
	conditions = conditions,
	groups = {
		conveyor = true
	},
	overview = "eco:stone",
    transport = {
        routes = {
            main = {
                -- middle to z+
                type = "container-3",
                points = {
                    { x=3.5, y=4, z=7.5 },
                    { x=3.5, y=4, z=15.5 }
                }
            }
        }
    },
    markers = {
		{
			texture = "building_lib_arrow.png",
			position = {x=0.5, y=0.2, z=1.5},
			rotation = {x=math.pi/2, y=0, z=math.pi},
			size = {x=10, y=10}
		}
	}
})

-- consumer building
building_lib.register_building("eco_transport:consumer", {
	catalog = MP .. "/schematics/conveyor_straight.zip",
	conditions = conditions,
	groups = {
		conveyor = true
	},
	overview = "eco:stone",
    transport = {
        routes = {
            main = {
                -- z- to middle
                type = "container-3",
                points = {
                    { x=3.5, y=4, z=-0.5 },
                    { x=3.5, y=4, z=7.5 }
                },
                on_end = function()
                    return { action = "remove" }
                end
            }
        }
    },
    markers = {
		{
			texture = "building_lib_arrow.png",
			position = {x=0.5, y=0.2, z=-0.5},
			rotation = {x=math.pi/2, y=0, z=0},
			size = {x=10, y=10}
		}
	}
})

-- straight conveyor with 2 lanes
building_lib.register_building("eco_transport:conveyor_straight", {
	catalog = MP .. "/schematics/conveyor_straight.zip",
    conditions = conditions,
	groups = {
		conveyor = true
	},
	overview = "eco:stone",
    transport = {
        routes = {
            lane1 = {
                -- z+
                type = "container-3",
                points = {
                    { x=3.5, y=4, z=-0.5 },
                    { x=3.5, y=4, z=15.5 }
                }
            },
            lane2 = {
                -- z-
                type = "container-3",
                points = {
                    { x=11.5, y=4, z=-0.5 },
                    { x=11.5, y=4, z=15.5 }
                }
            }
        }
    },
    markers = {
		{
			texture = "building_lib_arrow.png",
			position = {x=0.5, y=0.2, z=-0.5},
			rotation = {x=math.pi/2, y=0, z=0},
			size = {x=10, y=10}
		},{
			texture = "building_lib_arrow.png",
			position = {x=0.5, y=0.2, z=1.5},
			rotation = {x=math.pi/2, y=0, z=math.pi},
			size = {x=10, y=10}
		}
	}
})

minetest.register_chatcommand("transport_test", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
        local success, msg = eco_transport.add(mapblock_pos, "main", "container-3", {
            inventory = {"stuff"}
        })
        if not success then
            return false, msg
        end
		return true, "container added"
	end
})