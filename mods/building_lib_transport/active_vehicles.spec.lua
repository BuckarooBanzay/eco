
mtt.register("format/parse key", function(callback)
    local mapblock_pos = {x=10, y=-4, z=22}
    local path_name = "left"

    local key = building_lib_transport.format_key(mapblock_pos, path_name)
    local p, n = building_lib_transport.parse_key(key)

    assert(vector.equals(p, mapblock_pos))
    assert(n == path_name)

    callback()
end)


mtt.register("active vehicle", function(callback)
    local active_vehicle = building_lib_transport.place_vehicle("testcar", {x=0,y=0,z=0}, "left")

    assert(active_vehicle)
    assert(building_lib_transport.get_active_vehicle({x=0,y=0,z=0}, "left") == active_vehicle)

    building_lib_transport.remove_vehicle(active_vehicle)

    callback()
end)