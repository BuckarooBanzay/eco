
function eco_template.register_template_path(path)
    assert(core.path_exists(path), "template-path exists: '" .. path .. "'")
    local count = 0
    local t_start = core.get_us_time()

    -- register all templates in path
    for _, filename in ipairs(core.get_dir_list(path, false)) do
        if string.match(filename, "[%l|%d|_]+[.]zip$") then
            count = count + 1
            local template, err = eco_template.create_template_from_zip(path, filename)
            if err then
                -- fail hard
                error("could not load template: '"..path.."/"..filename.."': " .. err)
            end

            local prefix = string.sub(filename, 1, #filename - 4) -- ".zip"
            eco_api.register_template(prefix, template)
        end
    end

    local t_end = core.get_us_time()
    print("[eco] loaded " .. count .. " templates from '" .. path .. "' in " .. (t_end-t_start) .. " us")

    return count
end

-- create and register global template path last (overrides any previously defined template)
core.register_on_mods_loaded(function()
    core.mkdir(eco_template.world_template_path)
    eco_template.register_template_path(eco_template.world_template_path)
end)
