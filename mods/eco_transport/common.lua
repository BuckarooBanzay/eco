local micros_per_second = 1000*1000

local function flip_point(axis, max, point)
    point[axis] = max[axis] - point[axis]
end

local function transpose_point(axis1, axis2, point)
    point[axis1], point[axis2] = point[axis2], point[axis1]
end

-- rotates a single point
local function rotate_point(point, max, rotation)
    if rotation == 90 then
        flip_point("x", max, point)
        transpose_point("x", "z", point)
    elseif rotation == 180 then
        flip_point("x", max, point)
        flip_point("z", max, point)
    elseif rotation == 270 then
        flip_point("z", max, point)
        transpose_point("x", "z", point)
    end
end

-- rotates all the routes and returns a new route-set with given rotation
function eco_transport.rotate_routes(routes, building_size, rotation)
    if rotation == 0 then
        -- no rotation
        return routes
    end

    local max = vector.subtract(vector.multiply(building_size, 16), 1)
    local rotated_routes = {}

    for name, route in pairs(routes) do
        -- copy route and reset points field
        local rotated_route = table.copy(route)
        rotated_route.points = {}

        for _, point in ipairs(route.points) do
            -- copy point for modification
            point = table.copy(point)
            rotate_point(point, max, rotation)
            table.insert(rotated_route.points, point)
        end

        rotated_routes[name] = rotated_route
    end

    return rotated_routes
end

-- returns the direction (in mapblocks) of the given route
function eco_transport.get_connected_route_dir(route, building_size)
    local max = vector.subtract( vector.multiply(building_size, 16), 0.5)
    local min = { x=-0.5, y=-0.5, z=-0.5 }
    local dir = { x=0, y=0, z=0 }

    local last_point = route.points[#route.points]
    for _, axis in ipairs({"x", "y", "z"}) do
        if last_point[axis] == min[axis] then
            dir[axis] = -1
            break
        elseif last_point[axis] == max[axis] then
            dir[axis] = building_size[axis]
            break
        end
    end

    return dir
end

-- finds a connecting route-name in the target routes with given offset (in mapblocks, origin to origin)
function eco_transport.find_connected_route(source_route, target_routes, target_offset)
    local target_offset_blocks = vector.multiply(target_offset, 16)

    local last_source_point = source_route.points[#source_route.points]

    for name, target_route in pairs(target_routes) do
        if source_route.type ~= target_route.type then
            break
        end

        local first_target_point_rel = target_route.points[1]
        local first_target_point = vector.add(first_target_point_rel, target_offset_blocks)

        if vector.equals(first_target_point, last_source_point) then
            return name
        end
    end

end

function eco_transport.get_route_length(route)
    local l = 0
    for i=2,#route.points do
        local p1 = route.points[i-1]
        local p2 = route.points[i]
        l = l + vector.distance(p1, p2)
    end
    return l
end

function eco_transport.get_position_data(entry, now)
    now = now or minetest.get_us_time()

    local building_def, _, rotation = building_lib.get_building_def_at(entry.building_pos)
    if not building_def then
        return false, "no building found at " .. minetest.pos_to_string(entry.building_pos)
    end
    if not building_def.transport then
        return false, "building has no transport-definition"
    end

    local building_size = building_lib.get_building_size(building_def, rotation)
    local rotated_routes = eco_transport.rotate_routes(building_def.transport.routes, building_size, rotation)

    local route = rotated_routes[entry.route_name]
    if not route then
        return false, "route '" .. entry.route_name .. "' not found"
    end

    -- how much time (in seconds) has passed since start of the route
    local time_delta = (now - entry.route_start_time) / micros_per_second
    -- nodes travelled since start
    local nodes_travelled = entry.velocity * time_delta

    local pos_rel, direction, segment_num = eco_transport.get_point_in_route(route, nodes_travelled)

    local offset_pos = vector.subtract(vector.multiply(entry.building_pos, 16), 1)
    local pos_abs = vector.add(pos_rel, offset_pos)

    return {
        pos = pos_abs,
        velocity = direction,
        segment_num = segment_num
    }
end

local zero_velocity = { x=0, y=0, z=0 }

-- returns the point in the route, the velocity and the segment-number with given nodes
function eco_transport.get_point_in_route(route, node_count)
    if node_count == 0 then
        -- special case: start of route
        local direction = vector.direction(route.points[1], route.points[2])
        return route.points[1], direction, 1
    end

    if not route.length then
        -- TODO: refactor and calculate on startup
        -- calculate route-length and store it in the route-definition itself
        route.length = eco_transport.get_route_length(route)
    end

    if node_count >= route.length then
        -- special case: end of route
        return route.points[#route.points], zero_velocity, #route.points
    end

    local l = 0
    for i=2,#route.points do
        local p1 = route.points[i-1]
        local p2 = route.points[i]

        local diff = vector.distance(p1, p2)
        if node_count < l + diff then
            -- route segment matches
            local direction = vector.direction(p1, p2)
            local remaining_node_count = node_count - l
            local dir_offset = vector.multiply(direction, remaining_node_count)

            return vector.add(p1, dir_offset), direction, i-1
        end

        l = l + diff
    end

    -- no match: return end of route
    return route.points[#route.points], zero_velocity, #route.points
end

-- source: https://gist.github.com/jrus/3197011
local random = math.random
function eco_transport.new_uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end