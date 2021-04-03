function eco_checks.some(...)
    local checks = {...}
    return function(mapblock_pos)
        for _, check in ipairs(checks) do
            if check(mapblock_pos) then
                return true
            end
        end

        return false
    end
end