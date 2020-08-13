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


function eco_serialize.transform(options, mapblock, metadata)

  if options.rotate then
    local axis = options.rotate.axis
    local angle = options.rotate.angle
		local disable_orientation = options.disable_orientation

    local other1, other2 = get_axis_others(axis)

    if angle == 90 then
      eco_serialize.flip(other1, mapblock, metadata)
      eco_serialize.transpose(other1, other2, mapblock, metadata)
      if axis == "y" and not disable_orientation then
        eco_serialize.orient(90, mapblock)
      end
    elseif angle == 180 then
      eco_serialize.flip(other1, mapblock, metadata)
      eco_serialize.flip(other2, mapblock, metadata)
			if axis == "y" and not disable_orientation then
        eco_serialize.orient(180, mapblock)
      end
    elseif angle == 270 then
      eco_serialize.flip(other2, mapblock, metadata)
      eco_serialize.transpose(other1, other2, mapblock, metadata)
			if axis == "y" and not disable_orientation then
        eco_serialize.orient(270, mapblock)
      end
    end
  end

end
