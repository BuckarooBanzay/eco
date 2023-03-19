
local bakedclay = {
    ["white"] = {},
    ["yellow"] = {},
    ["black"] = {},
    ["natural"] = {},
    ["dark_grey"] = {},
    ["dark_green"] = {},
    ["pink"] = {},
    ["grey"] = {},
    ["magenta"] = {},
    ["brown"] = {},
    ["green"] = {},
    ["cyan"] = {},
    ["blue"] = {},
    ["red"] = {},
    ["violet"] = {},
    ["orange"] = {}
}

-- separate color-nodes and full moreblocks support
for name, def in pairs(bakedclay) do
    def.tiles = def.tiles or {"baked_clay_" .. name .. ".png"}
    def.sounds = def.sounds or eco_nodes.node_sound_stone()
    def.moreblocks = true

    eco_nodes.register("baked_clay_" .. name, def)
end
