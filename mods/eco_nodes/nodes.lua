
-- "default" nodes
local nodes = {
    ["brick"] = {
        tiles= {
            "default_brick.png^[transformFX",
            "default_brick.png"
        }
    },
    ["cobble"] = {
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
            "default_grass.png", "default_dirt.png", {
                name = "default_dirt.png^default_grass_side.png",
			    tileable_vertical = false
            }
        }
    },
    ["obsidian_block"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["obsidian_brick"] = {
        sounds = eco_nodes.node_sound_stone()
    },
    ["ice"] = {groups={slippery=3, cracky=1}},
    ["snow"] = {},
    ["glass"] = {
        tiles = {"default_glass.png", "default_glass_detail.png"},
        drawtype = "glasslike_framed_optional",
        use_texture_alpha = "clip",
        sunlight_propagates = true,
        paramtype = "light"
    },
}

for name, def in pairs(nodes) do
    def.description = "eco '" .. name .. "' node"
    def.tiles = def.tiles or {"default_" .. name .. ".png"}
    def.groups = def.groups or { cracky = 1 }

    minetest.register_node(":eco:" .. name, def)

    local stairsdef = table.copy(def)
    if #stairsdef.tiles > 1 and stairsdef.drawtype and stairsdef.drawtype:find("glass") then
        stairsdef.tiles = {stairsdef.tiles[1]}
        stairsdef.paramtype2 = nil
    end

    stairsplus:register_all("eco", name, "eco:" .. name, stairsdef)
end
