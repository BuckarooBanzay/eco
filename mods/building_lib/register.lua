
function building_lib.register(def)
	assert(type(def.name) == "string")
	building_lib.buildings[def.name] = def
end

function building_lib.register_placement(def)
	assert(type(def.name) == "string")
	building_lib.placements[def.name] = def
end
