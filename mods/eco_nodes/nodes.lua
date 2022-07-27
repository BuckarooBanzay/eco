
local nodes = {
    ["brick"] = {
        tiles = {
            "eco_brick.png^[transformFX",
            "eco_brick.png"
        }
    },
    ["cobble"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true
    },
    ["gravel"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true
    },
    ["dirt"] = {
        sounds = eco_nodes.node_sound_dirt()
    },
    ["grass"] = {
        sounds = eco_nodes.node_sound_dirt(),
        tiles = {
            "eco_grass.png", "eco_dirt.png", {
                name = "eco_dirt.png^eco_grass_side.png",
			    tileable_vertical = false
            }
        },
        moreblocks = true
    },
    ["steel_block"] = {},
    ["copperpatina"] = {tiles = {"moreblocks_copperpatina.png"}},
    ["coal_checker"] = {tiles = {"moreblocks_coal_checker.png"}},
    ["clean_glass"] = {tiles = {"moreblocks_clean_glass.png"}},
    ["grey_bricks"] = {tiles = {"moreblocks_grey_bricks.png"}},
    ["cactus_brick"] = {tiles = {"moreblocks_cactus_brick.png"}},
    ["obsidian_block"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["obsidian_brick"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["desert_sand"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true
    },
    ["silver_sand"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true
    },
    ["sand"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true
    },
    ["ice"] = {
        groups= {
            slippery=3,
            cracky=1
        },
        moreblocks = true
    },
    ["snow"] = {},
    ["glass"] = {
        tiles = {"eco_glass.png", "eco_glass_detail.png"},
        drawtype = "glasslike_framed_optional",
        use_texture_alpha = "clip",
        sunlight_propagates = true,
        paramtype = "light"
    },
}

for name, def in pairs(nodes) do
    eco_nodes.register(name, def)
end
