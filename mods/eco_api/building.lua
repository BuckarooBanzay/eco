
-- name -> {}
local buildings = {}

local function read_json(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return core.parse_json(content)
end

function eco_api.register_building_path(path)
    assert(core.path_exists(path), "building-path exists: '" .. path .. "'")
    -- register all buildings in path
    for _, filename in ipairs(core.get_dir_list(path, false)) do
        print(filename)
        local index = string.find(filename, "[.]json")
        if index then
            local prefix = string.sub(filename, 1, index-1)
            local zip_file_path = path .. "/" .. prefix .. ".zip"
            assert(core.path_exists(zip_file_path), "zip file exists '" .. zip_file_path .. "'")

            buildings[prefix] = {
                manifest = read_json(path .. "/" .. prefix .. ".json"),
                zip_file_path = zip_file_path
            }
        end
    end
end

-- create and register global building path last (overrides any previously defined building)
core.register_on_mods_loaded(function()
    local world_building_path = core.get_worldpath() .. "/buildings"
    core.mkdir(world_building_path)
    eco_api.register_building_path(world_building_path)
end)

function eco_api.get_building(name)
    return buildings[name]
end

function eco_api.save_building(name, building)
    -- TODO: save to global building path
    -- TODO: replace current definition with newly saved
end