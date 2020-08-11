
minetest.register_entity("eco_util:display", {
	physical = false,
	collisionbox = {0, 0, 0, 0, 0, 0},
	visual = "wielditem",
	visual_size = {x = 0.67, y = 0.67},
	textures = {"eco_util:display_node"},
	timer = 0,
	glow = 10,
	static_save = false, --TODO: wtf!?
	on_step = function(self, dtime)

		self.timer = self.timer + dtime

		-- remove after set number of seconds
		if self.timer > 5 then
			self.object:remove()
		end
	end,
})


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

function eco_util.display_mapblock_at_pos(pos)
  local mapblock_center = eco_util.get_mapblock_center(pos)
  minetest.add_entity(mapblock_center, "eco_util:display")
end
