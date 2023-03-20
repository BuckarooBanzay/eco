
-- playername -> name
local last_wielded_item = {}

-- check for tools
local function wield_check()
    for _, player in ipairs(minetest.get_connected_players()) do
        local itemstack = player:get_wielded_item()
        local playername = player:get_player_name()
        local name = itemstack and itemstack:get_name()
        -- TODO: check player:get_wield_index() to differenciate same-named items

        if last_wielded_item[playername] and name ~= last_wielded_item[playername] then
            -- last item got out of focus
            local item_def = minetest.registered_items[last_wielded_item[playername]]
            if item_def and type(item_def.on_blur) == "function" then
                item_def.on_blur(player)
            end
        end

        local item_def = minetest.registered_items[name]
        if item_def and type(item_def.on_step) == "function" then
            item_def.on_step(itemstack, player)
        end

        last_wielded_item[playername] = name
    end
    minetest.after(0, wield_check)
end

minetest.after(0, wield_check)
minetest.register_on_leaveplayer(function(player)
    last_wielded_item[player:get_player_name()] = nil
end)