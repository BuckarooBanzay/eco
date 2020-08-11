
local x = 7.5
minetest.register_node("eco_util:display_node", {
	tiles = {"eco_util_display.png"},
	use_texture_alpha = true,
	walkable = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- sides
			{-(x+.55), -(x+.55), -(x+.55), -(x+.45), (x+.55), (x+.55)},
			{-(x+.55), -(x+.55), (x+.45), (x+.55), (x+.55), (x+.55)},
			{(x+.45), -(x+.55), -(x+.55), (x+.55), (x+.55), (x+.55)},
			{-(x+.55), -(x+.55), -(x+.55), (x+.55), (x+.55), -(x+.45)},
			-- top
			{-(x+.55), (x+.45), -(x+.55), (x+.55), (x+.55), (x+.55)},
			-- bottom
			{-(x+.55), -(x+.55), -(x+.55), (x+.55), -(x+.45), (x+.55)}
		},
	},
	selection_box = {
		type = "regular",
	},
	paramtype = "light",
	groups = {dig_immediate = 3, not_in_creative_inventory = 1},
	drop = "",
})

minetest.register_entity("eco_util:display", {
	initial_properties = {
		physical = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		visual = "wielditem",
		visual_size = {x = 0.67, y = 0.67},
		textures = {"eco_util:display_node"},
		glow = 10,
	},

	timer = 0,

	on_step = function(self)
		local now = os.time()
		if now > self.data.expire then
			self.object:remove()
			return
		end
	end,
	on_activate = function(self, staticdata)
		self.data = minetest.deserialize(staticdata)

		if not self.data or not self.data.expire then
			self.object:remove()
			return
		end

		if self.data.text then
			local properties = self.object:get_properties()
			properties.nametag = self.data.text
			self.object:set_properties(properties)
		end
	end,
	get_staticdata = function(self)
		return minetest.serialize(self.data)
	end
})



function eco_util.display_mapblock_at_pos(pos, text, timeout)
  local mapblock_center = eco_util.get_mapblock_center(pos)
	local data = {
		expire = os.time() + (timeout or 5),
		text = text
	}
  return minetest.add_entity(mapblock_center, "eco_util:display", minetest.serialize(data))
end
