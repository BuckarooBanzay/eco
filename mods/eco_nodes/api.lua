function eco_nodes.register(name, def)
    def = def or {}
    def.description = def.description or "eco '" .. name .. "' node"
    def.tiles = def.tiles or {"eco_" .. name .. ".png"}
    def.groups = def.groups or { cracky = 1 }

    minetest.register_node(":eco:" .. name, def)

    if def.moreblocks then
        local stairsdef = table.copy(def)
        if #stairsdef.tiles > 1 and stairsdef.drawtype and stairsdef.drawtype:find("glass") then
            stairsdef.tiles = {stairsdef.tiles[1]}
            stairsdef.paramtype2 = nil
        end
        stairsplus:register_all("eco", name, "eco:" .. name, stairsdef)
    end
end

function eco_nodes.register_stone(stonename, cfg)
    eco_nodes.register(stonename, {
        tiles = {cfg.textures.stone},
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = cfg.moreblocks
    })

    eco_nodes.register(stonename .. "_block", {
        tiles = {cfg.textures.block},
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = cfg.moreblocks
    })

    eco_nodes.register(stonename .. "_brick", {
        tiles = {cfg.textures.brick},
        paramtype2 = "facedir",
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = cfg.moreblocks
    })
end

function eco_nodes.register_tree(treename, cfg)
    eco_nodes.register(treename .. "_tree", {
        tiles = {cfg.textures.tree_top, cfg.textures.tree_top, cfg.textures.tree},
        paramtype2 = "facedir",
        sounds = eco_nodes.node_sound_wood(),
        on_place = minetest.rotate_node
    })

    eco_nodes.register(treename .. "_wood", {
        tiles = {cfg.textures.wood},
        sounds = eco_nodes.node_sound_wood()
    })

    eco_nodes.register(treename .. "_leaves", {
        tiles = {cfg.textures.leaves},
        drawtype = "allfaces_optional"
    })
end