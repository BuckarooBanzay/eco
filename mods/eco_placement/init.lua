minetest.register_chatcommand("test", {
	func = function(name)
    local player = minetest.get_player_by_name(name)
    if not player then
      return false
    end

    local raybegin = vector.add(player:get_pos(),{x=0, y=player:get_properties().eye_height, z=0})
    local rayend = vector.add(raybegin, vector.multiply(player:get_look_dir(), 50))
    local ray = minetest.raycast(raybegin, rayend, true, false)
    ray:next() -- player
    local pointed_thing = ray:next()

    if not pointed_thing then
      return false, "out of range!"
    end

    if pointed_thing.type == "object" then
      local object = pointed_thing.ref
      if object and object.get_luaentity and object:get_luaentity() then
        return true, "hit entity: " .. object:get_luaentity().name
      end
      return false, "unknown entity"

    elseif pointed_thing.type == "node" then
			minetest.add_entity(pointed_thing.above, "eco_placement:display")
      return true, "hit node: " .. dump(pointed_thing.above)

    end
		return true
  end
})


minetest.register_entity("eco_placement:display", {
	physical = false,
	collisionbox = {0, 0, 0, 0, 0, 0},
	visual = "wielditem",
	visual_size = {x = 0.67, y = 0.67},
	textures = {"eco_placement:display_node"},
	timer = 0,
	glow = 10,

	on_step = function(self, dtime)

		self.timer = self.timer + dtime

		-- remove after set number of seconds
		if self.timer > 5 then
			self.object:remove()
		end
	end,
})


local x = 8
minetest.register_node("eco_placement:display_node", {
	tiles = {"eco_placement_display.png"},
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
			{-(x+.55), -(x+.55), -(x+.55), (x+.55), -(x+.45), (x+.55)},
			{-.55,-.55,-.55, .55,.55,.55},
		},
	},
	selection_box = {
		type = "regular",
	},
	paramtype = "light",
	groups = {dig_immediate = 3, not_in_creative_inventory = 1},
	drop = "",
})
