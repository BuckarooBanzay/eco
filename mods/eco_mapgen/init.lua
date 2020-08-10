local c_stone = minetest.get_content_id("default:stone")
local c_air = minetest.get_content_id("air")


minetest.register_on_generated(function(minp, maxp)

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()

	for z=minp.z,maxp.z do
	for x=minp.x,maxp.x do
	for y=minp.y,maxp.y do
		local index = area:index(x,y,z)
    if y == 0 then
      data[index] = c_stone
    else
      data[index] = c_air
    end
	end --y
	end --x
	end --z

  --vm:calc_lighting()
  vm:set_lighting({day=15, night=0})
	vm:set_data(data)
	vm:write_to_map()

end)
