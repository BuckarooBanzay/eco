
function eco_transport.register_entity_for_type(name, def)
    minetest.register_entity("eco_transport:" .. name, {
        initial_properties = def.initial_properties,
        on_activate = function(self, id)
            self.id = id
        end,
        on_step = function(self)
            local entry = eco_transport.get_entry(self.id)
            if not entry then
                print("entry not found: " .. self.id)
                self.object:remove()
                return
            end

            local data, err = eco_transport.get_position_data(entry)
            if not data then
                print("get_position_data error: " .. err)
                self.object:remove()
                return
            end

            -- TODO: only update if changed
            self.object:set_pos(data.pos)
            self.object:set_velocity(data.velocity)
        end,
        on_deactivate = function(self)
            -- called if player away
            eco_transport.change_visibility(self.id, false)
        end
    })
end