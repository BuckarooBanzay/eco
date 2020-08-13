
local streets = {}

function eco_api.register_street(def)
  streets[def.key] = def
end

function eco_api.get_streets()
  return streets
end

function eco_api.get_street(key)
  return streets[key]
end
