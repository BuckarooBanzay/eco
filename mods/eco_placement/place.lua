
function eco_placement.place_street(mapblock)

  local xplus_data = eco_grid.get_mapblock({ x=mapblock.x+1, y=mapblock.y, z=mapblock.z })
  local xminus_data = eco_grid.get_mapblock({ x=mapblock.x-1, y=mapblock.y, z=mapblock.z })
  local zplus_data = eco_grid.get_mapblock({ x=mapblock.x, y=mapblock.y, z=mapblock.z+1 })
  local zminus_data = eco_grid.get_mapblock({ x=mapblock.x, y=mapblock.y, z=mapblock.z-1 })

  local xplus = xplus_data and xplus_data.type == "street"
  local xminus = xminus_data and xminus_data.type == "street"
  local zplus = zplus_data and zplus_data.type == "street"
  local zminus = zminus_data and zminus_data.type == "street"

  local sides = 0

  if xplus then sides = sides + 1 end
  if xminus then sides = sides + 1 end
  if zplus then sides = sides + 1 end
  if zminus then sides = sides + 1 end

  local schema_dir

  if sides == 4 then
    schema_dir = minetest.get_modpath("eco_streets") .. "/schematics/street_all_sides"
  elseif sides == 3 then
    schema_dir = minetest.get_modpath("eco_streets") .. "/schematics/street_three_sides"
  elseif sides == 2 then
    schema_dir = minetest.get_modpath("eco_streets") .. "/schematics/street_straight"
  else
    schema_dir = minetest.get_modpath("eco_streets") .. "/schematics/street_straight"
  end

  local min = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
  eco_serialize.deserialize(min, schema_dir)

  eco_grid.set_mapblock(mapblock, {
    type = "street"
  })
end
