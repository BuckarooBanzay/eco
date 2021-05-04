local transport_list = {}

local function get_fractional_time()
    return minetest.get_us_time() / 1000 / 1000
end

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
        self.skip = 0
    end,
    on_punch = function() end,
    on_step = function(self)
        local transport = transport_list[self.id]
        if not transport then
            return self.object:remove()
        end

        local now = get_fractional_time()
        local expired = now - transport.start
        local progress = math.min(expired / transport.traversal_time, 1)
        if progress > 1 then
            -- let the animation do the movement
            return
        end

        local min = mapblock_lib.get_mapblock_bounds_from_mapblock(transport.mapblock_pos)
        local building_def = building_lib.get_building_at_pos(transport.mapblock_pos)

        if building_def.transport and building_def.transport.travel then
            local ctx = building_def.transport.travel(
                transport.mapblock_pos, {x=-1,y=0,z=0}, {x=1,y=0,z=0}, progress
            )

            local pos = vector.add(min, ctx.position)
            pos = vector.add(pos, {x=0, y=0.25, z=0})

            self.object:set_pos(pos)
            self.object:set_velocity(ctx.velocity)
            self.object:set_rotation(ctx.rotation)
        end

    end
})

local function dummy_move()
    local now = get_fractional_time()
    for id, ctx in pairs(transport_list) do
        if (ctx.start + ctx.traversal_time) <= now then
            -- done, TODO: next mapblock
            transport_list[id] = nil
            print("transport_list, removing: " .. id, dump(ctx))
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
            local id = "tx_" .. math.random(10000)
            transport_list[id] = {
                mapblock_pos = mapblock_pos,
                start = get_fractional_time(),
                traversal_time = building_def.transport.traversal_time
            }
            minetest.add_entity(min, "eco_transport:car1", id)
        end

        return true
    end
})
