
mtt.register("eco_mapgen building registration", function(callback)
    local building = eco_api.get_building("eco_mapgen_terrain_simple")
    assert(building)
    assert(building.manifest)
    assert(building.zip_file_path)
    callback()
end)