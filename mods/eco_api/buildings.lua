
local buildings = {}

function eco_api.register_building(def)
  buildings[def.key] = def
end

function eco_api.get_buildings()
  return buildings
end

function eco_api.get_building(key)
  return buildings[key]
end
