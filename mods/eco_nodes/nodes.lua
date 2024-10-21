
local nodes = {
    ["cobble"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true,
        mapcolor = { r=88, g=84, b=82 }
    },
    ["gravel"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true,
        mapcolor = { r=131, g=131, b=131 }
    },
    ["steel_block"] = {
        sounds = eco_nodes.node_sound_metal(),
        moreblocks = true,
        mapcolor = { r=194, g=194, b=194 }
    },
    ["steel_block_colorable"] = {
        sounds = eco_nodes.node_sound_metal(),
        tiles = {"eco_steel_block.png"},
        unifieddyes = true
    },
    ["silver_sandstone_block"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true,
        mapcolor = { r=192, g=190, b=179 }
    },
    ["silver_sandstone_block_colorable"] = {
        tiles = {"eco_silver_sandstone_block.png"},
        sounds = eco_nodes.node_sound_stone(),
        unifieddyes = true
    },
    ["silver_sandstone_brick"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true,
        mapcolor = { r=193, g=189, b=140 }
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
