
local function worker(ctx)
	ctx.pos = building_lib.iterator_next(ctx.pos1, ctx.pos2, ctx.pos)
	if not ctx.pos then
		return
	end

	local rel_pos = vector.subtract(ctx.pos, ctx.pos1)
	mapblock_lib.deserialize(ctx.pos, ctx.path .. "/mapblock_" .. minetest.pos_to_string(rel_pos))

	minetest.after(1, worker, ctx)
end

function building_lib.load(mapblock_pos, path)
	local manifest = building_lib.read_manifest(path)
	if not manifest then
		return false, "manifest not found"
	end

	local ctx = {
		pos1 = mapblock_pos,
		pos2 = vector.add(mapblock_pos, manifest.extends),
		pos = nil,
		path = path
	}

	minetest.after(0, worker, ctx)
	return true, "loading schematic from " .. path
end
