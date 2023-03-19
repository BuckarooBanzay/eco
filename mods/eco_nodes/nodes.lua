
local nodes = {
    ["cobble"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true
    },
    ["gravel"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true
    },
    ["steel_block"] = {
        sounds = eco_nodes.node_sound_metal(),
        moreblocks = true
    },
    ["steel_block_colorable"] = {
        sounds = eco_nodes.node_sound_metal(),
        tiles = {"eco_steel_block.png"},
        unifieddyes = true
    },
    ["clean_glass"] = {
        tiles = {"moreblocks_clean_glass.png"},
        drawtype = "glasslike_framed_optional",
        use_texture_alpha = "clip",
        sunlight_propagates = true,
        paramtype = "light",
        moreblocks = true
    },
    ["silver_sandstone_block"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true
    },
    ["silver_sandstone_block_colorable"] = {
        tiles = {"eco_silver_sandstone_block.png"},
        sounds = eco_nodes.node_sound_stone(),
        unifieddyes = true
    },
    ["silver_sandstone_brick"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true
    },
    ["silver_sandstone_brick_colorable"] = {
        tiles = {"eco_silver_sandstone_brick.png"},
        sounds = eco_nodes.node_sound_stone(),
        unifieddyes = true
    }
}

for name, def in pairs(nodes) do
    eco_nodes.register(name, def)
end
