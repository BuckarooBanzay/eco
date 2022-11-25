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
    -- simple sanity checks
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

    if #self.mapblock_poslist == 0 then
        -- first position, just add position
        table.insert(self.mapblock_poslist, mapblock_pos)
        return true
    end

    -- calculate difference to last position
    local last_mapblock_pos = self.mapblock_poslist[#self.mapblock_poslist]

    -- more sanity checks (corner cases)
    local last_building_info = building_lib.get_placed_building_info(last_mapblock_pos)
    if not last_building_info then
        return false, "previous building vanished"
    end

    local last_building_def = building_lib.get_building(last_building_info.name)
    if not last_building_def or not last_building_def.transport then
        return false, "previous building changed"
    end

    -- last -> current route
    local last_to_current_mapblock_pos = vector.subtract(mapblock_pos, last_mapblock_pos)

    for _, route in ipairs(last_building_def.transport.routes or {}) do
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