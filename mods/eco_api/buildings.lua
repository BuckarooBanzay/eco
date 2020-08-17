
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

function eco_api.get_building_by_type(type)
  local list = {}
  for _, def in pairs(buildings) do
    if def.type == type then
      table.insert(list, def)
    end
  end

  -- TODO cache result
  return list
end
