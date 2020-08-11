eco_serialize = {}

local MP = minetest.get_modpath("eco_serialize")

dofile(MP .. "/iterator_next.lua")
dofile(MP .. "/sort_pos.lua")
dofile(MP .. "/serialize.lua")
dofile(MP .. "/serialize_part.lua")
dofile(MP .. "/deserialize.lua")

minetest.register_chatcommand("test_serialize", {
	func = function(name)
    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()
    eco_serialize.serialize(pos, pos, minetest.get_worldpath() .. "/schems/test")
		return true
  end
})
