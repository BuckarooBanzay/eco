
function mapblock_lib.get_mapblock(pos)
	return vector.floor( vector.divide(pos, 16))
end

function mapblock_lib.get_mapblock_bounds_from_mapblock(block_pos)
	local min = vector.multiply(block_pos, 16)
  local max = vector.add(min, 15)
	return min, max
end

function mapblock_lib.get_mapblock_bounds(pos)
	local mapblock = vector.floor( vector.divide(pos, 16))
	return mapblock_lib.get_mapblock_bounds_from_mapblock(mapblock)
end
