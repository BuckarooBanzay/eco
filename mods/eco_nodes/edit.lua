
if minetest.settings:get_bool("eco_edit_mode", false) then
    -- enable edit mode, the hand can break anything
    minetest.override_item("", {
        range = 30,
        tool_capabilities = {
            groupcaps = {
                cracky = {
                    times = {
                        [1] = 0.1
                    },
                    uses = 0
                }
            }
        }
    })

    -- creative mode
    minetest.register_on_placenode(function()
        return true
    end)
end