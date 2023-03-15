function eco_nodes.register(name, def)
    def = def or {}
    def.description = def.description or "eco '" .. name .. "' node"
    def.tiles = def.tiles or {"eco_" .. name .. ".png"}
    def.groups = def.groups or { cracky = 1 }

    if def.unifieddyes then
        def.paramtype2 = "color"
        def.groups.ud_param2_colorable = 1
        def.palette = "unifieddyes_palette_extended.png"
    end

    minetest.register_node(":eco:" .. name, def)

    if def.moreblocks then
        local stairsdef = table.copy(def)
        if def.unifieddyes then
            -- split palette
            stairsdef.palette = "unifieddyes_palette_colorwallmounted.png"
            stairsdef.paramtype2 = "colorfacedir"
        end

        if #stairsdef.tiles > 1 and stairsdef.drawtype and stairsdef.drawtype:find("glass") then
            stairsdef.tiles = {stairsdef.tiles[1]}
            stairsdef.paramtype2 = nil
        end
        stairsplus:register_all("eco", name, "eco:" .. name, stairsdef)
    end
end

function eco_nodes.register_stone(stonename, cfg)
    eco_nodes.register(stonename, {
        description = "eco '" .. stonename .. "' stone",
        tiles = {cfg.textures.stone},
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = cfg.moreblocks
    })

    eco_nodes.register(stonename .. "_block", {
        description = "eco '" .. stonename .. "' block",
        tiles = {cfg.textures.block},
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = cfg.moreblocks
    })

    eco_nodes.register(stonename .. "_brick", {
        description = "eco '" .. stonename .. "' brick",
        tiles = {cfg.textures.brick},
        paramtype2 = "facedir",
        sounds = eco_nodes.node_sound_stone(),
        moreblocks = cfg.moreblocks
    })
end

function eco_nodes.register_tree(treename, cfg)
    eco_nodes.register(treename .. "_tree", {
        description = "eco '" .. treename .. "' trunk",
        tiles = {cfg.textures.tree_top, cfg.textures.tree_top, cfg.textures.tree},
        paramtype2 = "facedir",
        sounds = eco_nodes.node_sound_wood(),
        on_place = minetest.rotate_node
    })

    eco_nodes.register(treename .. "_wood", {
        description = "eco '" .. treename .. "' wood",
        tiles = {cfg.textures.wood},
        sounds = eco_nodes.node_sound_wood(),
        moreblocks = true
    })

    eco_nodes.register(treename .. "_leaves", {
        description = "eco '" .. treename .. "' leaves",
        tiles = {cfg.textures.leaves},
        sunlight_propagates = true,
		paramtype = "light",
        drawtype = "allfaces_optional"
    })
end

function eco_nodes.register_plant(flowername, cfg)
    eco_nodes.register(flowername, {
        description = "eco '" .. flowername .. "' plant",
        tiles = {cfg.texture},
        walkable = false,
        waving = 1,
        sunlight_propagates = true,
		paramtype = "light",
        drawtype = "plantlike",
    })
end