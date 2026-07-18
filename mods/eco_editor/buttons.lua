
local basetile = "eco_steel_block.png"

core.register_node("eco_editor:button_save", {
    tiles = {basetile .. "^eco_editor_save.png"},
    groups = { not_in_creative_inventory = 1 },
    on_punch = function(pos, _, player)
        local meta = core.get_meta(pos)

        local mapblock_pos = core.string_to_pos(meta:get_string("origin_mapblock_pos"))
        local template_size = core.string_to_pos(meta:get_string("template_size"))
        local template_name = meta:get_string("template_name")

        local template = assert(eco_api.get_template(template_name))

        local zip_filename = eco_api.world_template_path .. "/" .. template_name .. ".zip"

        local mapblock_pos1 = vector.add(mapblock_pos, 1)
        local mapblock_pos2 = vector.add(mapblock_pos1, vector.add(template_size, -1))

        local options = {
            delay = 0,
            progress_callback = function(p)
                meta = core.get_meta(pos)
                meta:set_string("infotext", "Saving: " .. math.floor(p*100) .. "%")
            end
        }
        core.chat_send_player(player:get_player_name(), "Starting to save template '" .. template_name .. "'")
        local f = io.open(zip_filename, "wb")
        local z = mtzip.zip(f)

        Promise.async(function(await)
            await(mapblock_lib.serialize_area_to_zip(z, mapblock_pos1, mapblock_pos2, options))

            z:add("eco.json", core.write_json(template.manifest))
            z:close()
            f:close()

            -- reload templates from world path
            eco_api.register_template_path(eco_api.world_template_path)

            core.chat_send_player(player:get_player_name(), "Template saved in '" .. zip_filename .. "'")
            meta = core.get_meta(pos)
            meta:set_string("infotext", "")
        end)
    end
})

core.register_node("eco_editor:button_exit", {
    tiles = {basetile .. "^eco_editor_exit.png"},
    groups = { not_in_creative_inventory = 1 },
    on_punch = function(pos)
        local meta = core.get_meta(pos)

        local mapblock_pos1 = core.string_to_pos(meta:get_string("origin_mapblock_pos"))
        local template_size = core.string_to_pos(meta:get_string("template_size"))

        local mapblock_pos2 = vector.add(mapblock_pos1, vector.add(template_size, 1))

        for mapblock_pos in mapblock_lib.pos_iterator(mapblock_pos1, mapblock_pos2) do
            mapblock_lib.clear_mapblock(mapblock_pos)
        end
    end
})