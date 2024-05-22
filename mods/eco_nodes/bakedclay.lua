
local bakedclay = {
    ["white"] = {
        mapcolor = { r=231, g=223, b=225 }
    },
    ["yellow"] = {
        mapcolor = { r=155, g=136, b=75 }
    },
    ["black"] = {
        mapcolor = { r=32, g=32, b=32 }
    },
    ["natural"] = {
        mapcolor = { r=229, g=217, b=180 }
    },
    ["dark_grey"] = {
        mapcolor = { r=64, g=64, b=64 }
    },
    ["dark_green"] = {
        mapcolor = { r=45, g=70, b=42 }
    },
    ["pink"] = {
        mapcolor = { r=183, g=150, b=160 }
    },
    ["grey"] = {
        mapcolor = { r=150, g=148, b=149 }
    },
    ["magenta"] = {
        mapcolor = { r=118, g=93, b=119 }
    },
    ["brown"] = {
        mapcolor = { r=48, g=39, b=31 }
    },
    ["green"] = {
        mapcolor = { r=93, g=112, b=70 }
    },
    ["cyan"] = {
        mapcolor = { r=60, g=96, b=100 }
    },
    ["blue"] = {
        mapcolor = { r=59, g=68, b=93 }
    },
    ["red"] = {
        mapcolor = { r=107, g=54, b=53 }
    },
    ["violet"] = {
        mapcolor = { r=70, g=52, b=83 }
    },
    ["orange"] = {
        mapcolor = { r=154, g=116, b=75 }
    }
}

-- separate color-nodes and full moreblocks support
for name, def in pairs(bakedclay) do
    def.tiles = def.tiles or {"baked_clay_" .. name .. ".png"}
    def.sounds = def.sounds or eco_nodes.node_sound_stone()
    def.moreblocks = true

    eco_nodes.register("baked_clay_" .. name, def)
end
