function eco_checks.biome(biome_key)
    return function(mapblock_pos)
        local _, key = eco_mapgen.get_biome(mapblock_pos)
        return key == biome_key
    end
end