
function eco_util.get_mapblock_center(pos)
	local mapblock = vector.floor( vector.divide(pos, 16))
	return vector.add(vector.multiply(mapblock, 16), 7.5)
end


function eco_util.get_mapblock_bounds(pos)
	local mapblock = vector.floor( vector.divide(pos, 16))
  local min = vector.multiply(mapblock, 16)
  local max = vector.add(min, 15)
	return min, max
end
