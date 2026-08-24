
local nodes = {
    ["dirt"] = {
        sounds = eco_nodes.node_sound_dirt(),
        moreblocks = true,
        mapcolor = { r=96, g=67, b=41 }
    },
    ["dry_dirt"] = {
        sounds = eco_nodes.node_sound_dirt(),
        moreblocks = true,
        mapcolor = { r=178, g=136, b=90 }
    },
    ["grass"] = {
        sounds = eco_nodes.node_sound_dirt(),
        tiles = {
            "eco_grass.png", "eco_dirt.png", {
                name = "eco_dirt.png^eco_grass_side.png",
			    tileable_vertical = false
            }
        },
        moreblocks = true,
        mapcolor = { r=97, g=138, b=53 }
    },
    ["dry_grass"] = {
        sounds = eco_nodes.node_sound_dirt(),
        tiles = {
            "eco_dry_grass.png", "eco_dry_dirt.png", {
                name = "eco_dry_dirt.png^eco_dry_grass_side.png",
			    tileable_vertical = false
            }
        },
        moreblocks = true,
        mapcolor = { r=208, g=172, b=87 }
    },
    ["silver_sand"] = {
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = true,
        mapcolor = { r=193, g=191, b=179 }
    },
    ["ice"] = {
        groups= {
            slippery=3,
            cracky=1
        },
        moreblocks = true,
        mapcolor = { r=167, g=206, b=247 }
    },
    ["snow"] = {
        mapcolor = { r=224, g=225, b=238 }
    }
}

for name, def in pairs(nodes) do
    eco_nodes.register(name, def)
end
