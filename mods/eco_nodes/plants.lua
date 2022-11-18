
local flowers = {
    "tulip",
    "chrysanthemum_green",
    "dandelion_white",
    "dandelion_yellow",
    "delphinium",
    "geranium",
    "lazarus",
    "mannagrass",
    "rose",
    "thistle",
    "tulip",
    "tulip_black",
    "viola",
}

for _, flowername in ipairs(flowers) do
    eco_nodes.register_plant(flowername, {
        texture = "eco_flowers_" .. flowername .. ".png"
    })
end

for i = 1,5 do
    eco_nodes.register_plant("grass_" .. i, {
        texture = "eco_grass_" .. i .. ".png"
    })
    eco_nodes.register_plant("dry_grass_" .. i, {
        texture = "eco_dry_grass_" .. i .. ".png"
    })
end