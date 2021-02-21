
minetest.register_on_mods_loaded(function()
	-- disable various abm's
	for i, abm in ipairs(minetest.registered_abms) do
		if abm.mod_origin == "default" then
			minetest.registered_abms[i] = nil
		elseif abm.mod_origin == "farming" then
			minetest.registered_abms[i] = nil
		elseif abm.mod_origin == "flowers" then
			minetest.registered_abms[i] = nil
		elseif abm.mod_origin == "moreblocks" then
			minetest.registered_abms[i] = nil
		end
	end

	-- disable various lbm's
	for i, lbm in ipairs(minetest.registered_lbms) do
		if lbm.mod_origin == "default" then
			minetest.registered_abms[i] = nil
		elseif lbm.mod_origin == "moreblocks" then
			minetest.registered_abms[i] = nil
		else
			print(dump(lbm))
		end
	end

	-- disable various globalsteps
	for i, globalstep in ipairs(minetest.registered_globalsteps) do
		local info = minetest.callback_origins[globalstep]
		if info.mod == "player_api" then
			minetest.registered_globalsteps[i] = nil
		end
	end
end)
