local MP = minetest.get_modpath("eco_buildings")

building_lib.register_building("eco_buildings:transmission_line_foundation", {
    catalog = {
        filename = MP .. "/schematics/transmission_line.zip",
        offset = { x=0, y=0, z=0 },
        size = { x=1, y=1, z=1 }
    },
    conditions = {
        {
            -- flat surface
            ["*"] = { empty = true },
            ["underground"] = { group = "flat_surface"}
        },{
            -- water
            ["*"] = { group = "water" },
            ["underground"] = { group = "flat_surface"}
        }
    },
    remove_conditions = {
        {["above"] = { empty = true }}
    },
    groups = {
        transmission_line_foundation = true,
        transmission_line_support = true
    },
    replace = function(mapblock_pos)
		if eco_mapgen.mapgen and eco_mapgen.mapgen.is_water(mapblock_pos) then
			return {
				["air"] = "eco:water_source"
			}
		end
	end,
    overview = "eco:steel_block"
})

building_lib.register_building("eco_buildings:transmission_line_support", {
    catalog = {
        filename = MP .. "/schematics/transmission_line.zip",
        offset = { x=0, y=1, z=0 },
        size = { x=1, y=1, z=1 }
    },
    conditions = {
        {
            -- flat surface
            ["*"] = { empty = true },
            ["underground"] = { group = "transmission_line_support"}
        }
    },
    remove_conditions = {
        {["above"] = { empty = true }}
    },
    groups = {
        transmission_line_support = true
    },
    overview = "eco:steel_block"
})

building_lib.register_building("eco_buildings:transmission_line_cable_holder", {
    catalog = {
        filename = MP .. "/schematics/transmission_line.zip",
        offset = { x=0, y=2, z=0 },
        size = { x=1, y=1, z=1 }
    },
    conditions = {
        {
            -- flat surface
            ["*"] = { empty = true },
            ["underground"] = { group = "transmission_line_support"}
        }
    },
    groups = {
        transmission_line = true
    },
    markers = {
        {
            texture = "building_lib_arrow.png",
            position = {x=1, y=0.2, z=0.5},
            rotation = {x=math.pi/2, y=0, z=math.pi/2},
            size = {x=10, y=10}
        }
    },
    overview = "eco:steel_block"
})

building_lib.register_building("eco_buildings:transmission_line_cable", {
    catalog = {
        filename = MP .. "/schematics/transmission_line.zip",
        offset = { x=1, y=2, z=0 },
        size = { x=1, y=1, z=1 }
    },
    conditions = {
        {
            -- flat surface and nearby transmission lines
            ["*"] = { empty = true, near_group_flat = "transmission_line" }
        }
    },
    groups = {
        transmission_line = true
    },
    markers = {
        {
            texture = "building_lib_arrow.png",
            position = {x=1, y=0.2, z=0.5},
            rotation = {x=math.pi/2, y=0, z=math.pi/2},
            size = {x=10, y=10}
        }
    },
    overview = "eco:baked_clay_black"
})