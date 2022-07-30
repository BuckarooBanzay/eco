
local trees = {
    "acacia",
    "pine",
    "jungle",
    "birch",
    "oak"
}

for _, tree in ipairs(trees) do
    eco_nodes.register_tree(tree, {
        textures = {
            tree = "eco_" .. tree .. "_tree.png",
            tree_top = "eco_" .. tree .. "_tree_top.png",
            wood = "eco_" .. tree .. "_wood.png",
            leaves = "eco_" .. tree .. "_leaves.png"
        }
    })
end
