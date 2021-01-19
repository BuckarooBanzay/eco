
function eco_mapgen.landscape_generator(height_generator)
	return {
		get_info = function(mapblock)
			local height = height_generator.get_mapblock_height(mapblock)

			if mapblock.y ~= height then
				return { type = "none" }
			end

			-- collect neighbor elevations and count
			local hm = {}
			local elevated_neighbor_count = 0
			for x=-1,1 do
				hm[x] = hm[x] or {}
				for z=-1,1 do
					local neighbor_height = height_generator.get_mapblock_height({ x=mapblock.x+x, z=mapblock.z+z })

					if neighbor_height > height then
						-- neighbor is higher
						hm[x][z] = true
						elevated_neighbor_count = elevated_neighbor_count + 1
					end
				end
			end

			if elevated_neighbor_count == 0 then
				return { type = "flat" }
			end

			-- straight slopes
			if hm[-1][0] and not hm[1][0] and not hm[0][-1] and not hm[0][1] then
				return { type = "slope", direction = "x-" }
			elseif not hm[-1][0] and hm[1][0] and not hm[0][-1] and not hm[0][1] then
				return { type = "slope", direction = "x+" }
			elseif not hm[-1][0] and not hm[1][0] and hm[0][-1] and not hm[0][1] then
				return { type = "slope", direction = "z-" }
			elseif not hm[-1][0] and not hm[1][0] and not hm[0][-1] and hm[0][1] then
				return { type = "slope", direction = "z+" }
			end

			-- z- / x- / z+ / x+
			if hm[0][-1] and hm[-1][0] and not hm[0][1] and not hm[1][0] then
				return { type = "slope_inner", direction = "x-z-" }
			elseif not hm[0][-1] and hm[-1][0] and hm[0][1] and not hm[1][0] then
				return { type = "slope_inner", direction = "x-z+" }
			elseif not hm[0][-1] and not hm[-1][0] and hm[0][1] and hm[1][0] then
				return { type = "slope_inner", direction = "x+z+" }
			elseif hm[0][-1] and not hm[-1][0] and not hm[0][1] and hm[1][0] then
				return { type = "slope_inner", direction = "x+z-" }
			end

			if hm[-1][-1] and not hm[-1][1] and not hm[1][1] and not hm[1][-1] then
				return { type = "slope_outer", direction = "x-z-" }
			elseif not hm[-1][-1] and hm[-1][1] and not hm[1][1] and not hm[1][-1] then
				return { type = "slope_outer", direction = "x-z+" }
			elseif not hm[-1][-1] and not hm[-1][1] and hm[1][1] and not hm[1][-1] then
				return { type = "slope_outer", direction = "x+z+" }
			elseif not hm[-1][-1] and not hm[-1][1] and not hm[1][1] and hm[1][-1] then
				return { type = "slope_outer", direction = "x+z-" }
			end

			return { type = "flat" }
		end
	}
end
