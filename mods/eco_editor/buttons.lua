
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

        local path_prefix = eco_api.world_template_path .. "/" .. template_name

        local mapblock_pos1 = vector.add(mapblock_pos, 1)
        local mapblock_pos2 = vector.add(mapblock_pos1, vector.add(template_size, -1))

        local options = {
            delay = 0
        }
        core.chat_send_player(player:get_player_name(), "Starting to save template '" .. template_name .. "'")
        mapblock_lib.create_catalog(path_prefix .. ".zip", mapblock_pos1, mapblock_pos2, options):next(function()
            -- reload templates from world path
            eco_api.register_template_path(eco_api.world_template_path)
            core.chat_send_player(player:get_player_name(), "Template saved in '" .. path_prefix .. "'")
        end)

        core.safe_file_write(path_prefix .. ".json", core.write_json(template.manifest))
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