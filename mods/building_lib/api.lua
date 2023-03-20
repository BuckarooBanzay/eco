
-- name -> building_def
local buildings = {}

function building_lib.register_building(name, def)
	def.name = name
	def.placement = def.placement or "mapblock_lib"

	-- try to validate the building/placement combo
	local placement = building_lib.get_placement(def.placement)
	assert(placement, "placement not found: " .. def.placement)
	if type(placement.validate) == "function" then
		local success, err_msg = placement.validate(placement, def)
		if not success then
			error("validation failed for " .. def.name .. " with message: " .. err_msg)
		end
	end

	buildings[name] = def
end

function building_lib.register_alias(alias, original_name)
	-- copy original and re-add to building-table
	local building_def = table.copy(original_name)
	building_def.alias = true
	buildings[alias] = building_def
end

function building_lib.get_building(name)
    return buildings[name]
end

function building_lib.get_buildings()
    return buildings
end

-- name -> placement_def
local placements = {}

function building_lib.register_placement(name, def)
	def.name = name
	placements[name] = def
end

function building_lib.get_placement(name)
    return placements[name]
end

-- name -> condition_def
local conditions = {}

function building_lib.register_condition(name, def)
	def.name = name
	conditions[name] = def
end

function building_lib.get_condition(name)
    return conditions[name]
end

-- name -> autoplace_def
local autoplacers = {}

function building_lib.register_autoplacer(name, def)
	assert(type(def.buildings) == "table")
	def.name = name
	autoplacers[name] = def
end

function building_lib.get_autoplacers()
	return autoplacers
end

function building_lib.get_autoplacer(name)
	return autoplacers[name]
end