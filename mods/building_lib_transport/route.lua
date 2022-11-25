local Route = {}
local Route_mt = { __index = Route }

function building_lib_transport.create_route()
    local self = {
        -- mapblock offset in fractions of a mapblock (1=first mapblock, 2.5=half into the second mapblock)
        index_pos = 1,
        mapblock_poslist = {},
        route_def_list = {}
	}
	return setmetatable(self, Route_mt)
end

function Route:add(mapblock_pos)
    local building_info = building_lib.get_placed_building_info(mapblock_pos)
    if not building_info then
        return false, "no building found"
    end

    local building_def = building_lib.get_building(building_info.name)
    if not building_def then
        return false, "unknown building"
    end

    if not building_def.transport then
        return false, "transport not supported '" .. building_info.name .. "'"
    end

    -- TODO: rotate transport def

    local last_rel_pos = {x=0, y=0, z=0}
    if #self.mapblock_poslist > 0 then
        -- calculate difference to last position
        local last_pos = self.mapblock_poslist[#self.mapblock_poslist]
        last_rel_pos = vector.subtract(last_pos, mapblock_pos)
    end

    for _, route in ipairs(building_def.transport.routes) do
        if vector.equals(last_rel_pos, route.from) then
            -- TODO
        end
    end

    table.insert(self.route_def_list, {})
    table.insert(self.mapblock_poslist, mapblock_pos)
    return true
end

function Route:get_pos()
    if self:is_finished() then
        return
    end

    local mb_index = math.floor(self.index_pos)
    local rest = self.index_pos - mb_index

    local route_def = self.route_def_list[mb_index]

    return mb_index, rest
end

function Route:move(f)
    self.index_pos = self.index_pos + f
    return self:get_pos()
end

function Route:is_finished()
    return self.index_pos >= #self.mapblock_poslist
end