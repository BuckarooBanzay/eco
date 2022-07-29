
function building_lib.register_building(name, def)
	def.name = name
	assert(type(def.placement) == "string", "placement is not a string on " .. def.name)

	-- try to validate the building/placement combo
	local placement = building_lib.placements[def.placement]
	assert(placement, "placement not found: " .. def.placement)
	if type(placement.validate) == "function" then
		local success, err_msg = placement.validate(placement, def)
		if not success then
			error("validation failed for " .. def.name .. " with message: " .. err_msg)
		end
	end

	building_lib.buildings[name] = def
end

function building_lib.register_placement(name, def)
	def.name = name
	building_lib.placements[name] = def
end

function building_lib.register_condition(name, def)
	def.name = name
	building_lib.conditions[name] = def
end
