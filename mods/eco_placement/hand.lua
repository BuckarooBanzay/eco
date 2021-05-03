minetest.override_item("", {
    on_secondary_use = function(_, player)
        print("on_secondary_use")
        local mapblock_pos = eco_placement.get_pointed_mapblock_pos(player)

        if mapblock_pos then
            local min, max = mapblock_lib.get_mapblock_bounds_from_mapblock(mapblock_pos)

            local delta_pos = vector.subtract(max, min)
            local epos = vector.add(min, {
                x = delta_pos.x / 2,
                y = 20,
                z = delta_pos.z / 2
            })

            local texture = "default_tool_diamondpick.png"
            local data = {
                properties = {
                    visual = "upright_sprite",
                    visual_size = {x = 1, y = 1},
                    textures = {texture},
                    glow = 10,
                    physical = true,
                    collide_with_objects = false,
                    pointable = true
                },
                mapblock_pos = mapblock_pos
            }

            minetest.add_entity(epos, "eco_placement:entity", minetest.serialize(data))
        end

    end
})

minetest.register_entity("eco_placement:entity", {
    initial_properties = {},
    static_save = false,

    on_step = function() end,

    on_punch = function(self)
        print("on_punch")
        self.object:remove()
    end,

    on_rightclick = function(self)
        print("on_rightclick")
        self.object:remove()
    end,

    get_staticdata = function(self) return minetest.serialize(self.data) end,

    on_activate = function(self, staticdata)
        self.data = minetest.deserialize(staticdata)

        if not self.data then
            self.object:remove()
            return
        end

        self.object:set_properties(self.data.properties)
    end
})
