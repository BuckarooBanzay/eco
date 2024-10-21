-- name -> def
local categories = {}

function eco_api.register_category(name, category_def)
    categories[name] = category_def
end

function eco_api.get_category_list()
    local list = {}
    for name in pairs(categories) do
        table.insert(list, name)
    end
    return list
end

function eco_api.get_category(name)
    return categories[name]
end

function eco_api.get_categories()
    return categories
end

-- name -> list<building_def>
local building_category_map = {}

minetest.register_on_mods_loaded(function()
    -- collect
    for _, building_def in pairs(building_lib.get_buildings()) do
        if type(building_def.category) == "string" then
            local list = building_category_map[building_def.category]
            if not list then
                list = {}
                building_category_map[building_def.category] = list
            end

            table.insert(list, building_def)
        end
    end

    -- sort
    for _, list in pairs(building_category_map) do
        table.sort(list, function(b1, b2)
            return (b1.description or b1.name) < (b2.description or b2.name)
        end)
    end
end)

function eco_api.get_buildings_in_category(name)
    return building_category_map[name]
end