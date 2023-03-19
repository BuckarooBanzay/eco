
if minetest.settings:get_bool("eco_edit_mode", false) then
    -- enable edit mode, the hand can break anything
    minetest.override_item("", {
        range = 15,
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
end