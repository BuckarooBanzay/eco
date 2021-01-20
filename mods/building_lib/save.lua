
local function worker(ctx)
	ctx.pos = building_lib.iterator_next(ctx.pos1, ctx.pos2, ctx.pos)
	if not ctx.pos then
		minetest.chat_send_player(ctx.playername, "saving to " .. ctx.path .. " complete")
		return
	end

	local rel_pos = vector.subtract(ctx.pos, ctx.pos1)
	mapblock_lib.serialize(ctx.pos, ctx.path .. "/mapblock_" .. minetest.pos_to_string(rel_pos))

	minetest.after(1, worker, ctx)
end

function building_lib.save(mapblock_pos1, mapblock_pos2, path, playername)
	-- create directory to save things in
	minetest.mkdir(path)

	-- sort positions
	mapblock_pos1, mapblock_pos2 = mapblock_lib.sort_pos(mapblock_pos1, mapblock_pos2)

	local ctx = {
		playername = playername,
		pos1 = mapblock_pos1,
		pos2 = mapblock_pos2,
		pos = nil,
		path = path
	}

	minetest.after(0, worker, ctx)
end
