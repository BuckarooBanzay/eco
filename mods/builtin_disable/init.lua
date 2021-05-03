
minetest.register_on_mods_loaded(function()
	--TODO: this shouldn't work... (removing items while in the ipairs loop)

	-- disable various abm's
	for i, abm in ipairs(minetest.registered_abms) do
		if abm.mod_origin == "default" then
			table.remove(minetest.registered_abms, i)
		elseif abm.mod_origin == "farming" then
			table.remove(minetest.registered_abms, i)
		elseif abm.mod_origin == "flowers" then
			table.remove(minetest.registered_abms, i)
		elseif abm.mod_origin == "moreblocks" then
			table.remove(minetest.registered_abms, i)
		end
	end

	-- disable various lbm's
	for i, lbm in ipairs(minetest.registered_lbms) do
		if lbm.mod_origin == "default" then
			table.remove(minetest.registered_lbms, i)
		elseif lbm.mod_origin == "moreblocks" then
			table.remove(minetest.registered_lbms, i)
		else
			print(dump(lbm))
		end
	end

	-- disable various globalsteps
	for i, globalstep in ipairs(minetest.registered_globalsteps) do
		local info = minetest.callback_origins[globalstep]
		if info.mod == "player_api" then
			table.remove(minetest.registered_globalsteps, i)
		end
	end
end)
