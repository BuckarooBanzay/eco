
function eco_transport.register_entity_for_type(name, def)
    minetest.register_entity("eco_transport:" .. name, {
        initial_properties = def.initial_properties,
        on_activate = function(self, id)
            print(dump({
                fn = "on_activate",
                id = id
            }))
            self.id = id
        end,
        on_step = function(self)
            local entry, visible = eco_transport.get_entry(self.id)
            if not entry or not visible then
                self:remove()
                return
            end
            -- not updated yet or the entry has been updated
            if not self.last_update or entry.last_update > self.last_update then
                print("would update " .. self.id .. ", last_update: " .. entry.last_update)
                local data, err = eco_transport.get_position_data(entry)
                if not data then
                    print("get_position_data error: " .. err)
                    self:remove()
                    return
                end

                self:set_pos(data.pos)
                self:set_velocity(data.velocity)
                self.last_update = entry.last_update
            end
        end,
        on_deactivate = function(self)
            -- called if player away
            print(dump({
                fn = "on_deactivate",
                id = self.id
            }))
            eco_transport.change_visibility(self.id, false)
        end
    })
end