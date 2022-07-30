
local function pos_2d_key_fn(pos)
    return minetest.hash_node_position({ x=pos.x, y=0, z=pos.z })
end

eco_mapgen.get_biome_data = memoize(eco_mapgen.get_biome_data, pos_2d_key_fn)
eco_mapgen.prepare_decoration_list = memoize(eco_mapgen.prepare_decoration_list, function(s) return s end)
eco_mapgen.get_slope_info = memoize(eco_mapgen.get_slope_info, minetest.hash_node_position)