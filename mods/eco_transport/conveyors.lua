local MP = minetest.get_modpath("eco_transport")

local conditions = {
    {
        -- flat surface
        ["*"] = { empty = true },
        ["underground"] = { group = "flat_surface"}
    }
}

building_lib.register_building("eco_transport:conveyor_end", {
    catalog = {
		filename = MP .. "/schematics/conveyor.zip",
		offset = {x=0, y=0, z=0},
		size = {x=1, y=1, z=1}
	},
    conditions = conditions,
    groups = {
        conveyor = true
    },
    overview = "eco:stone",
    transport = {
        routes = {
            right = {
                type = "container-3",
                points = {
                    { x=12, y=3, z=3 },
                    { x=12, y=3, z=15.5 }
                }
            },
            left = {
                type = "container-3",
                points = {
                    { x=5, y=3, z=15.5 },
                    { x=5, y=3, z=3 }
                }
            }
        }
    },
    markers = {
        {
            type = "arrow",
            pos = { z=1, x=0.333 },
            rotation = "z+"
        },{
            type = "arrow",
            pos = { z=1, x=-0.333 },
            rotation = "z-"
        }
    }
})

building_lib.register_building("eco_transport:conveyor_straight", {
    catalog = {
		filename = MP .. "/schematics/conveyor.zip",
		offset = {x=0, y=0, z=1},
		size = {x=1, y=1, z=1}
	},
    conditions = conditions,
    groups = {
        conveyor = true
    },
    overview = "eco:stone",
    transport = {
        routes = {
            right = {
                type = "container-3",
                points = {
                    { x=12, y=3, z=-0.5 },
                    { x=12, y=3, z=15.5 }
                }
            },
            left = {
                type = "container-3",
                points = {
                    { x=5, y=3, z=15.5 },
                    { x=5, y=3, z=-0.5 }
                }
            }
        }
    },
    markers = {
        {
            type = "arrow",
            pos = { z=1, x=0.333 },
            rotation = "z+"
        },{
            type = "arrow",
            pos = { z=1, x=-0.333 },
            rotation = "z-"
        },{
            type = "arrow",
            pos = { z=-1, x=0.333 },
            rotation = "z+"
        },{
            type = "arrow",
            pos = { z=-1, x=-0.333 },
            rotation = "z-"
        }
    }
})

building_lib.register_building("eco_transport:conveyor_corner", {
    catalog = {
		filename = MP .. "/schematics/conveyor.zip",
		offset = {x=0, y=0, z=2},
		size = {x=1, y=1, z=1}
	},
    conditions = conditions,
    groups = {
        conveyor = true
    },
    overview = "eco:stone",
    transport = {
        routes = {
            right = {
                type = "container-3",
                points = {
                    { x=12, y=3, z=-0.5 },
                    { x=12, y=3, z=5 },
                    { x=15.5, y=3, z=5 }
                }
            },
            left = {
                type = "container-3",
                points = {
                    { x=15.5, y=3, z=12 },
                    { x=5, y=3, z=12 },
                    { x=5, y=3, z=-0.5 }
                }
            }
        }
    },
    markers = {
        {
            type = "arrow",
            pos = { z=-1, x=0.333 },
            rotation = "z+"
        },{
            type = "arrow",
            pos = { z=-1, x=-0.333 },
            rotation = "z-"
        },{
            type = "arrow",
            pos = { x=1, z=0.333 },
            rotation = "x-"
        },{
            type = "arrow",
            pos = { x=1, z=-0.333 },
            rotation = "x-"
        }
    }
})

building_lib.register_building("eco_transport:conveyor_levelshift", {
    catalog = {
		filename = MP .. "/schematics/conveyor.zip",
		offset = {x=1, y=0, z=0},
		size = {x=1, y=2, z=1}
	},
    conditions = conditions,
    groups = {
        conveyor = true
    },
    overview = "eco:stone",
    transport = {
        routes = {
            right = {
                type = "container-3",
                points = {
                    { x=12, y=3, z=-0.5 },
                    { x=12, y=3, z=8 },
                    { x=12, y=19, z=8 },
                    { x=12, y=19, z=15.5 }
                }
            },
            left = {
                type = "container-3",
                points = {
                    { x=5, y=19, z=15.5 },
                    { x=5, y=19, z=8 },
                    { x=5, y=3, z=8 },
                    { x=5, y=3, z=-0.5 }
                }
            }
        }
    },
    markers = {
        {
            type = "arrow",
            pos = { z=1, y=1, x=0.333 },
            rotation = "z+"
        },{
            type = "arrow",
            pos = { z=1, y=1, x=-0.333 },
            rotation = "z-"
        },{
            type = "arrow",
            pos = { z=-1, x=0.333 },
            rotation = "z+"
        },{
            type = "arrow",
            pos = { z=-1, x=-0.333 },
            rotation = "z-"
        }
    }
})

minetest.register_chatcommand("transport_test", {
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(pos)
        local success, msg = eco_transport.add(mapblock_pos, "right", "container_3", {
            inventory = {"stuff"}
        })
        if not success then
            return false, msg
        end
        return true, "container added"
	end
})

minetest.register_chatcommand("dump_route", {
    params = "[routename]",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(pos)
        local route, err = eco_transport.get_route(mapblock_pos, param)
        if err then
            return false, err
        end

        print(dump(route))
        return true, dump(route)
	end
})