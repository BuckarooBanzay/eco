
minetest.register_entity("eco_transport:car1", {
    visual = "cube",
    mesh = "",
    textures = {
        "mesecar_car1top.png^[multiply:#ff0000",
        "mesecar_carbase.png",
        "mesecar_car1rightside.png",
        "mesecar_car1leftside.png",
        "mesecar_car1front.png",
        "mesecar_car1back.png"
    },
    visual_size = {x=1.5, y=1.5},
    wield_scale = {x=1, y=1, z=1},
    collisionbox = {-0.75, -0.75, -0.75, 0.75, 0.75, 0.75},
    on_rightclick = function(_, clicker)
        print("on_rightclick", clicker:get_player_name())
    end,
    on_activate = function(self, staticdata, dtime_s)
    end,
    get_staticdata = function(self)
        return ""
    end,
    on_punch = function(self, puncher)
    end,
    on_step = function(self, dtime)
    end
})

minetest.register_chatcommand("transport_test", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "player not found"
		end

		local pos = player:get_pos()
        minetest.add_entity(pos, "eco_transport:car1")

		return true
	end
})
