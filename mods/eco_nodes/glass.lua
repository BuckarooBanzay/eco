
eco_nodes.register("clean_glass", {
    tiles = {"moreblocks_clean_glass.png"},
    drawtype = "glasslike_framed_optional",
    use_texture_alpha = "clip",
    sunlight_propagates = true,
    paramtype = "light",
    moreblocks = true
})

eco_nodes.register("framed_glass", {
    tiles = {
        { name = "framedglass_steel_frame.png", color = "white" },
		"framedglass_whiteglass.png",
    },
    drawtype = "glasslike_framed",
    use_texture_alpha = "blend",
    sunlight_propagates = true,
    paramtype = "light",
    unifieddyes = true
})
