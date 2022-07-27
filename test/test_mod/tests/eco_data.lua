
return function(callback)
    print("eco_data")

    local pos1 = {x=0, y=0, z=0}
    local pos2 = {x=0, y=2, z=0}

    eco_data.set(pos1, {x=1})
    eco_data.set(pos2, {y=2})

    local data = eco_data.get(pos1)
    assert(data.x == 1)
    data = eco_data.get(pos2)
    assert(data.y == 2)

    eco_data.set(pos1, nil)
    data = eco_data.get(pos1)
    assert(not data)

    callback()
end
