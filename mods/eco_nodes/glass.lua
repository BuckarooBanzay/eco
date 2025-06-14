
eco_nodes.register("clean_glass", {
    tiles = {"moreblocks_clean_glass.png"},
    drawtype = "glasslike_framed_optional",
    use_texture_alpha = "clip",
    sunlight_propagates = true,
    paramtype = "light",
    moreblocks = true,
    mapcolor = { r=247, g=247, b=247, a=50 },
    sounds = eco_nodes.node_sound_glass()
})
