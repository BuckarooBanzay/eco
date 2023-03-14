
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

for name, def in pairs(bakedclay) do
    name = "baked_clay_" .. name
    def.moreblocks = true
    def.tiles = {name .. ".png"}
    eco_nodes.register(name, def)
end
