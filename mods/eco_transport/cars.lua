local transport_list = {}

minetest.register_entity("eco_transport:car1", {
    visual = "cube",
    textures = {
        "mesecar_car1top.png",
        "mesecar_carbase.png",
        "mesecar_car1rightside.png",
        "mesecar_car1leftside.png",
        "mesecar_car1front.png",
        "mesecar_car1back.png"
    },
    visual_size = {x = 1.5, y = 1.5},
    wield_scale = {x = 1, y = 1, z = 1},
    physical = false,
    static_save = false,
    collisionbox = {-0.75, -0.75, -0.75, 0.75, 0.75, 0.75},
    on_rightclick = function(_, clicker)
        print("on_rightclick", clicker:get_player_name())
    end,
    on_activate = function(self, staticdata)
        self.id = staticdata
    end,
    on_punch = function() end,
    on_step = function(self)
        local transport = transport_list[self.id]
        if not transport then
            return self.object:remove()
        end

        local now = os.time()
        if now - transport.mtime < 0.2 then
            return
        end

        transport.mtime = now

        local min = mapblock_lib.get_mapblock_bounds_from_mapblock(transport.mapblock_pos)
        local building_def = building_lib.get_building_at_pos(transport.mapblock_pos)

        if building_def.transport and building_def.transport.travel then
            local ctx = building_def.transport.travel(
                transport.mapblock_pos, {x=-1,y=0,z=0}, {x=1,y=0,z=0}, transport.progress, 1.6
            )

            self.object:set_pos(vector.add(min, ctx.position))
            self.object:set_velocity(ctx.velocity)
        end

    end
})

local function dummy_move()
    for id, ctx in pairs(transport_list) do
        ctx.progress = ctx.progress + 0.05
        if ctx.progress > 1 then
            transport_list[id] = nil
        end
    end

    minetest.after(0.2, dummy_move)
end

dummy_move()

minetest.register_chatcommand("transport_test", {
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "player not found"
        end

        local pos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(pos)
        local min = mapblock_lib.get_mapblock_bounds_from_mapblock(mapblock_pos)
        local building_def = building_lib.get_building_at_pos(mapblock_pos)

        if building_def.transport and building_def.transport.travel then
            transport_list["1"] = {
                progress = 0,
                mapblock_pos = mapblock_pos,
                mtime = os.time()
            }
            minetest.add_entity(min, "eco_transport:car1", "1")
        end

        return true
    end
})
