

mtt.register("uuid", function(callback)
    assert(building_lib_interconnect.new_uuid())
    assert(building_lib_interconnect.new_uuid() ~= building_lib_interconnect.new_uuid())
    callback()
end)