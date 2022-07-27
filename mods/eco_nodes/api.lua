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

function eco_nodes.register_stone(name, def)
    def.sounds = def.sounds or eco_nodes.node_sound_stone()
    eco_nodes.register(name, def)
end