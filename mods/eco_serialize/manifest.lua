
function eco_serialize.get_manifest(schema_dir)
  local file = io.open(schema_dir .. "/manifest.json","r")
  if file then
    local json = file:read("*a")
    return minetest.parse_json(json)
  else
    return nil
  end
end
