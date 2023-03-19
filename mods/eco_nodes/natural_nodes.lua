
local nodes = {
    ["dirt"] = {
        sounds = eco_nodes.node_sound_dirt(),
        moreblocks = true
    },
    ["dry_dirt"] = {
        sounds = eco_nodes.node_sound_dirt(),
        moreblocks = true
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
    ["dry_grass"] = {
        sounds = eco_nodes.node_sound_dirt(),
        tiles = {
            "eco_dry_grass.png", "eco_dry_dirt.png", {
                name = "eco_dry_dirt.png^eco_dry_grass_side.png",
			    tileable_vertical = false
            }
        },
        moreblocks = true
    },
    ["silver_sand"] = {
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
    ["snow"] = {}
}

for name, def in pairs(nodes) do
    eco_nodes.register(name, def)
end
