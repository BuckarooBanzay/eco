
mtt.register("eco_api.get_cityblock_bounds", function(callback)
    local min, max = eco_api.get_cityblock_bounds({ x=0, y=0, z=0 })
    assert(vector.equals(min, { x=0, y=0, z=0 }))
    assert(vector.equals(max, { x=19, y=19, z=19 }))

    min, max = eco_api.get_cityblock_bounds({ x=-1, y=0, z=0 })
    assert(vector.equals(min, { x=-20, y=0, z=0 }))
    assert(vector.equals(max, { x=-1, y=19, z=19 }))
    callback()
end)