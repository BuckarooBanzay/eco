local max = { x=15, y=15, z=15 }

local function flip_point(axis, point)
    point[axis] = max[axis] - point[axis]
end

local function transpose_point(axis1, axis2, point)
    point[axis1], point[axis2] = point[axis2], point[axis1]
end

local function rotate_point(point, rotation)
    if rotation == 90 then
        flip_point("x", point)
        transpose_point("x", "z", point)
    elseif rotation == 180 then
        flip_point("x", point)
        flip_point("z", point)
    elseif rotation == 270 then
        flip_point("z", point)
        transpose_point("x", "z", point)
    end
end

function eco_transport.rotate_routes(routes, rotation)
    if rotation == 0 then
        -- no rotation
        return routes
    end

    local rotated_routes = {}

    for name, route in pairs(routes) do
        -- copy route and reset points field
        local rotated_route = table.copy(route)
        rotated_route.points = {}

        for _, point in ipairs(route.points) do
            -- copy point for modification
            point = table.copy(point)
            rotate_point(point, rotation)
            table.insert(rotated_route.points, point)
        end

        rotated_routes[name] = rotated_route
    end

    return rotated_routes
end