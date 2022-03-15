
local plants = {
    ["grass_1"] = {},
    ["grass_2"] = {},
    ["grass_3"] = {},
    ["grass_4"] = {},
    ["grass_5"] = {}
}

for name, def in pairs(plants) do
    def.description = "eco '" .. name .. "' plant"
    def.tiles = def.tiles or {"eco_" .. name .. ".png"}
    def.groups = def.groups or { cracky = 1 }
    def.inventory_image = "eco_" .. name .. ".png"
	def.wield_image = "eco_" .. name .. ".png"
    def.drawtype = "plantlike"
	def.waving = 1
    def.paramtype = "light"
	def.sunlight_propagates = true
	def.walkable = false
    def.selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -5 / 16, 6 / 16},
	}

    minetest.register_node(":eco:" .. name, def)
end