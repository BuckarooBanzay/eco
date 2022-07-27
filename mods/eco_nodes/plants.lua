
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
    "grass_1",
    "grass_2",
    "grass_3",
    "grass_4",
    "grass_5"
}

local grass = {
    "grass_1",
    "grass_2",
    "grass_3",
    "grass_4",
    "grass_5"
}

for _, flowername in ipairs(flowers) do
    eco_nodes.register_plant(flowername, {
        texture = "eco_flowers_" .. flowername .. ".png"
    })
end

for _, grassname in ipairs(grass) do
    eco_nodes.register_plant(grassname, {
        texture = "eco_" .. grassname .. ".png"
    })
end