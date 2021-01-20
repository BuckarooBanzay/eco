
function building_lib.allocate(mapblock_pos, path)
	local manifest = building_lib.read_manifest(path)
	if not manifest then
		return false, "manifest not found"
	end

	local pos1 = mapblock_pos
	local pos2 = vector.add(mapblock_pos, manifest.extends)

	mapblock_lib.display_mapblock(pos1, minetest.pos_to_string(pos2), 5)
	mapblock_lib.display_mapblock(pos2, minetest.pos_to_string(pos2), 5)
end
