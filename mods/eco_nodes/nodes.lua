
-- "default" nodes
local nodes = {
    ["brick"] = {
        tiles= {
            "eco_brick.png^[transformFX",
            "eco_brick.png"
        }
    },
    ["cobble"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["gravel"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["stone"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["stone_block"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["stone_brick"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["desert_sandstone"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["desert_sandstone_block"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["desert_sandstone_brick"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["desert_stone"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["desert_stone_block"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["desert_stone_brick"] = {
        sounds = eco_nodes.node_sound_stone()
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
        }
    },
    ["pine_tree"] = {},
    ["pine_wood"] = {},
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
    ["desert_sand"] = {},
    ["silver_sand"] = {},
    ["sand"] = {},
    ["ice"] = {groups={slippery=3, cracky=1}},
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
    def.description = "eco '" .. name .. "' node"
    def.tiles = def.tiles or {"eco_" .. name .. ".png"}
    def.groups = def.groups or { cracky = 1 }

    minetest.register_node(":eco:" .. name, def)

    local stairsdef = table.copy(def)
    if #stairsdef.tiles > 1 and stairsdef.drawtype and stairsdef.drawtype:find("glass") then
        stairsdef.tiles = {stairsdef.tiles[1]}
        stairsdef.paramtype2 = nil
    end

    stairsplus:register_all("eco", name, "eco:" .. name, stairsdef)
end
