
function building_lib.register_building(def)
	assert(type(def.name) == "string", "name not defined")
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

	building_lib.buildings[def.name] = def
end

function building_lib.register_placement(def)
	assert(type(def.name) == "string")
	building_lib.placements[def.name] = def
end

function building_lib.register_condition(def)
	assert(type(def.name) == "string")
	building_lib.conditions[def.name] = def
end
