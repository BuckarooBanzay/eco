local function get_mapblock_center(pos)
	local mapblock = vector.floor( vector.divide(pos, 16))
	return vector.add(vector.multiply(mapblock, 16), 7.5)
end

minetest.register_craftitem("eco_placement:wand", {
	description = "Placement wand",
	inventory_image = "eco_placement_wand.png",
	on_use = function(itemstack, player)
		local raybegin = vector.add(player:get_pos(),{x=0, y=player:get_properties().eye_height, z=0})
    local rayend = vector.add(raybegin, vector.multiply(player:get_look_dir(), 50))
    local ray = minetest.raycast(raybegin, rayend, true, false)
    ray:next() -- player

    local pointed_thing = ray:next()

    if not pointed_thing then
      return itemstack
    end

		if pointed_thing.type == "node" then
			local mapblock_center = get_mapblock_center(pointed_thing.above)
			minetest.add_entity(mapblock_center, "eco_placement:display")
    end
		return itemstack
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

local function get_mapblock_bounds(pos)
	local mapblock = vector.floor( vector.divide(pos, 16))
  local min = vector.multiply(mapblock, 16)
  local max = vector.add(min, 15)
	return min, max
end

local MP = minetest.get_modpath("eco_placement")

minetest.register_chatcommand("load_test", {
	func = function(name)
    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()
    local min = get_mapblock_bounds(pos)
    minetest.place_schematic(min, MP .. "/schematics/street_all_sides.mts", 0, {}, true, {})
		return true
  end
})
