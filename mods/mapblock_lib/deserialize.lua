local air_content_id = minetest.get_content_id("air")

-- local nodename->id cache
local local_nodename_to_id_mapping = {} -- name -> id

local function localize_nodeids(node_mapping, node_ids)
	local foreign_nodeid_to_name_mapping = {} -- id -> name
	for k, v in pairs(node_mapping) do
		foreign_nodeid_to_name_mapping[v] = k
	end

	for i, node_id in ipairs(node_ids) do
		local node_name = foreign_nodeid_to_name_mapping[node_id]
		local local_node_id = local_nodename_to_id_mapping[node_name]
		if not local_node_id then
			if minetest.registered_nodes[node_name] then
				-- node is locally available
				local_node_id = minetest.get_content_id(node_name)
			else
				-- node is not available here
				local_node_id = air_content_id
			end
			local_nodename_to_id_mapping[node_name] = local_node_id

		end

		node_ids[i] = local_node_id
	end
end

local function deserialize_part(min, max, data, metadata, replace)
	local manip = minetest.get_voxel_manip()
	local e1, e2 = manip:read_from_map(min, max)
	local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})

	local node_data = manip:get_data()
	local param1 = manip:get_light_data()
	local param2 = manip:get_param2_data()

	local j = 1
	for z=min.z,max.z do
		for y=min.y,max.y do
			for x=min.x,max.x do
				local i = area:index(x,y,z)
				if replace or node_data[i] == air_content_id then
					node_data[i] = data.node_ids[j]
					param1[i] = data.param1[j]
					param2[i] = data.param2[j]
				end
				j = j + 1
			end
		end
	end

	manip:set_data(node_data)
	manip:set_light_data(param1)
	manip:set_param2_data(param2)
	manip:write_to_map()

	-- deserialize metadata
	if metadata and metadata.meta then
		for pos_str, md in pairs(metadata.meta) do
			local relative_pos = minetest.string_to_pos(pos_str)
			local absolute_pos = vector.add(min, relative_pos)
			minetest.get_meta(absolute_pos):from_table(md)
		end
	end
end

function mapblock_lib.deserialize(mapblock_pos, filename, options)
	local min, max = mapblock_lib.get_mapblock_bounds_from_mapblock(mapblock_pos)

	local mapblock = mapblock_lib.read_mapblock(filename .. ".bin")
	local manifest = mapblock_lib.read_manifest(filename .. ".manifest.json")

	if not mapblock then
		return false, "mapblock data not found"
	end

	localize_nodeids(manifest.node_mapping, mapblock.node_ids)
	deserialize_part(min, max, mapblock, manifest.metadata, options.replace)

	return true
end
