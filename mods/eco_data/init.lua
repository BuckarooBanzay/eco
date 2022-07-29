local storage = minetest.get_mod_storage()
eco_data = mapblock_lib.create_data_storage(storage)

minetest.register_chatcommand("eco_data_get", {
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local ppos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(ppos)
        local data = eco_data:get(mapblock_pos)
        return true, "Data for mapblock " .. minetest.pos_to_string(mapblock_pos) .. ": " .. dump(data)
    end
})