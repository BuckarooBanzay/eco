
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

    local max = vector.subtract( vector.multiply(building_size, 16), 1)
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