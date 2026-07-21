
mtt.register("eco_mapgen template registration", function(callback)
    local template = eco_api.get_template("eco_mapgen_terrain_simple")
    assert(template)
    assert(template.manifest)
    assert(template.zip_filename)
    callback()
end)

mtt.emerge_area({x=0,y=0,z=0}, {x=100,y=0,z=0})