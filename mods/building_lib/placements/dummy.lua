
building_lib.register_placement("dummy", {
    check = function() return true end,
    get_size = function(_, _, building_def, rotation)
        local size = building_def.size or {x=1,y=1,z=1}
        return mapblock_lib.rotate_size(size, rotation)
    end,
    place = function(_, _, _, _, _, callback) callback() end
})