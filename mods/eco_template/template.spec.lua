
mtt.register("eco_template.check_template_name", function(callback)

    local ok_names = {
        "my_template",
        "t1",
        "template_xy_1"
    }
    local bad_names = {
        ".",
        "/",
        "./",
        "%",
        "()\\"
    }

    for _, name in ipairs(ok_names) do
        local success, err = eco_template.check_template_name(name)
        assert(success, "name: '"..name.."'")
        assert(not err)
    end

    for _, name in ipairs(bad_names) do
        local success, err = eco_template.check_template_name(name)
        assert(not success, "name: '"..name.."'")
        assert(err)
    end

    callback()
end)