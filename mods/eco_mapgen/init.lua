local MP = minetest.get_modpath("eco_mapgen")

minetest.register_on_generated(function(minp, maxp)

	local min_mapblock = eco_util.get_mapblock(minp)
	local max_mapblock = eco_util.get_mapblock(maxp)

	local i = 0

	for z=min_mapblock.z,max_mapblock.z do
	for x=min_mapblock.x,max_mapblock.x do
	for y=min_mapblock.y,max_mapblock.y do

		if y == 0 then
			local pos = eco_util.get_mapblock_bounds_from_mapblock({ x=x, y=y, z=z })
			eco_serialize.deserialize(pos, MP .. "/schematics/green", true)
		end

		i = i + 1

	end --y
	end --x
	end --z

	assert(i == 125)

end)
