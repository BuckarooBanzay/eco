local colors = {
    red = { color = "#FF0000" },
    green = { color = "#00FF00" },
    blue = { color = "#0000FF" },
    yellow = { color = "#FFFF00" },
    cyan = { color = "#00FFFF" },
    magenta = { color = "#FF00FF" }
}

local box = {
    type = "fixed",
    fixed = {
        -- {x1, y1, z1, x2, y2, z2}
        {-1.5, -1.5, -1.5, 1.5, 1.5, 1.5}
    }
}

-- containers in node form
for name, entry in pairs(colors) do
    minetest.register_node("eco_transport:container_" .. name, {
        description = "Container",
        -- top, bottom
        tiles = {
            "eco_container_top.png^[colorize:" .. entry.color .. ":150"
        },
        wield_scale = { x=0.5, y=0.5, z=0.5 },

        selection_box = box,
        collision_box = box,

        drawtype = "mesh",
        mesh = "eco_container.obj",

        groups = {
            cracky = 3,
            oddly_breakable_by_hand = 1
        }
    })
end

local selectionbox = {
    -1.5, -1.5, -1.5,
    1.5, 1.5, 1.5
}

-- transport container
eco_transport.register_type("container_3", {
    initial_properties = {
        visual = "mesh",
        mesh = "eco_container.obj",
        physical = false,
		static_save = false,
		collisionbox = selectionbox,
        selectionbox = selectionbox,
        visual_size = { x=10, y=10, z=10 },
        textures = {
            "eco_container_top.png^[colorize:blue:150"
        }
    }
})