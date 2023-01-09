function building_lib_transport.register_connection(b1_name, b1_rot, b1_con, dir, b2_name, b2_rot, b2_con)
    print(dump({
        name = "building_lib_transport.register_connection",
        b1_name = b1_name,
        b1_rot = b1_rot,
        b1_con = b1_con,
        dir = dir,
        b2_name = b2_name,
        b2_rot = b2_rot,
        b2_con = b2_con
    }))
end

local rotations = {0, 90, 180, 270}

function building_lib_transport.register_connection_rotated(b1_name, b1_con, dir, b2_name, b2_con)
    local building_def = building_lib.get_building(b1_name)
    for _, rotation in ipairs(rotations) do
        local size = building_lib.get_building_size(building_def, rotation)
        local max_size = vector.subtract(size, 1)
        local rotated_dir = mapblock_lib.rotate_pos(dir, max_size, rotation)
        building_lib_transport.register_connection(
            b1_name, rotation, b1_con,
            rotated_dir,
            b2_name, rotation, b2_con
        )
    end
end
