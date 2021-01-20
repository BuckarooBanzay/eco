
function building_lib.write_manifest(manifest, path)
	local filename = path .. "/manifest.json"
	local file = io.open(filename,"w")
	local json = minetest.write_json(manifest)
	if file and file:write(json) and file:close() then
		return
	else
		error("write to '" .. filename .. "' failed!")
	end
end

function building_lib.read_manifest(path)
	local filename = path .. "/manifest.json"
	local file = io.open(filename,"r")
	if file then
		local json = file:read("*a")
		return minetest.parse_json(json)
	else
		return nil
	end
end
