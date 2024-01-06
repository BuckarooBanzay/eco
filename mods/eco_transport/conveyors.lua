local MP = minetest.get_modpath("eco_transport")

building_lib.register_building("eco_transport:conveyor_straight", {
	catalog = MP .. "/schematics/conveyor_straight.zip",
	conditions = {
		{
			-- flat surface
			["*"] = { empty = true },
			["underground"] = { group = "flat_surface"}
		}
	},
	groups = {
		conveyor = true
	},
	overview = "eco:stone",

    transport = {
        routes = {
            {
                -- z+
                type = "container-3",
                points = {
                    { x=3.5, y=4, z=-0.5 },
                    { x=3.5, y=4, z=15.5 }
                }
            },{
                -- z-
                type = "container-3",
                points = {
                    { x=11.5, y=4, z=-0.5 },
                    { x=11.5, y=4, z=15.5 }
                }
            }
        }
    }
})