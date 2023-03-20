function eco_buildings.replacement_randomizer(replacement_map)
	return function()
		local replacements = {}
		for _, group in pairs(replacement_map) do
			local sync_i
			for src, choices in pairs(group) do
				if not sync_i then
					sync_i = math.random(#choices)
				end

				local new_nodename = choices[sync_i]
				if src ~= new_nodename then
					replacements[src] = new_nodename
				end
			end
		end
		return replacements
	end
end