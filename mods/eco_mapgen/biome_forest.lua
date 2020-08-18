local MP = minetest.get_modpath("eco_mapgen")

local noise_params = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	seed = 5477835,
	octaves = 2,
	persist = 0.5
}

local tree_schematics = {
  MP .. "/schematics/grass_with_trees_1",
  MP .. "/schematics/grass_with_trees_2",
  MP .. "/schematics/grass_with_trees_3",
  MP .. "/schematics/grass_with_trees_4",
  MP .. "/schematics/grass_with_trees_5"
}

local grass_schematic = MP .. "/schematics/grass_flat"
local ore_deposit_schematic = MP .. "/schematics/ore_deposit"

eco_mapgen.register_biome({
  key = "grass",
  match = function(mapblock)
    local is_in_water = mapblock.y <= eco_mapgen.get_water_height()
    local map_height = eco_mapgen.get_mapblock_height(mapblock)

    return mapblock.y == map_height and not is_in_water
  end,
  schemas = {
    flat = function(mapblock)
			if math.random(10) == 1 then
				return ore_deposit_schematic
			end

      local map_lengths_xyz = {x=1, y=1, z=1}
      local perlin = minetest.get_perlin_map(noise_params, map_lengths_xyz)
      local perlin_map = {}
      perlin:get_2d_map_flat({x=mapblock.x, y=mapblock.z}, perlin_map)

      local value = perlin_map[1]

      if value > 0.8 then
        return tree_schematics[math.random(#tree_schematics)]
      else
        return grass_schematic
      end
    end,

    slope = MP .. "/schematics/grass_slope",
    slope_inner = MP .."/schematics/grass_slope_inner_corner",
    slope_outer = MP .."/schematics/grass_slope_outer_corner"
  }
})
