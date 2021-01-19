local function get_axis_others(axis)
	if axis == "x" then
		return "y", "z"
	elseif axis == "y" then
		return "x", "z"
	elseif axis == "z" then
		return "x", "y"
	else
		error("Axis must be x, y, or z!")
	end
end


function mapblock_lib.transform(options, mapblock, metadata)

	if options.replace then
		mapblock_lib.replace(options.replace, mapblock)
	end

	if options.rotate then
		local axis = options.rotate.axis
		local angle = options.rotate.angle
		local disable_orientation = options.rotate.disable_orientation

		local other1, other2 = get_axis_others(axis)

		if angle == 90 then
			mapblock_lib.flip(other1, mapblock, metadata)
			mapblock_lib.transpose(other1, other2, mapblock, metadata)
			if axis == "y" and not disable_orientation then
				mapblock_lib.orient(90, mapblock)
			end
		elseif angle == 180 then
			mapblock_lib.flip(other1, mapblock, metadata)
			mapblock_lib.flip(other2, mapblock, metadata)
			if axis == "y" and not disable_orientation then
				mapblock_lib.orient(180, mapblock)
			end
		elseif angle == 270 then
			mapblock_lib.flip(other2, mapblock, metadata)
			mapblock_lib.transpose(other1, other2, mapblock, metadata)
			if axis == "y" and not disable_orientation then
				mapblock_lib.orient(270, mapblock)
			end
		end
	end

end
