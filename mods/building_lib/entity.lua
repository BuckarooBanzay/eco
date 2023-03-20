
-- id -> true
local active_entities = {}

minetest.register_entity("building_lib:display", {
	initial_properties = {
		physical = false,
        static_save = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		visual = "upright_sprite",
		visual_size = {x=10, y=10},
		glow = 10
	},
	on_step = function(self)
		if not active_entities[self.id] then
			-- not valid anymore
			self.object:remove()
		end
	end
})

function building_lib.add_entity(pos, id)
	active_entities[id] = true
	local ent = minetest.add_entity(pos, "building_lib:display")
	local luaent = ent:get_luaentity()
	luaent.id = id
	return ent
end

function building_lib.remove_entities(id)
	active_entities[id] = nil
end
