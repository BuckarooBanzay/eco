
local function select_biome(biomes, temperature, humidity)
    local selected_score = -1
    local selected_biome

    for _, biome in ipairs(biomes) do
        local score = math.abs(temperature - biome.temperature) + math.abs(humidity - biome.humidity)
        if not selected_biome or score > selected_score then
            selected_biome = biome
            selected_score = score
        end
    end

    return selected_biome
end

function building_lib.create_mapgen(opts)
    assert(#opts.biomes > 0)

    local map_lengths_xyz = {x=1, y=1, z=1}
    opts.water_level = opts.water_level or 0

    opts.height_params = opts.height_params or {
        offset = 0,
        scale = 1,
        spread = {x=64, y=64, z=64},
        seed = 5477835,
        octaves = 2,
        persist = 0.5
    }

    opts.temperature_params = opts.temperature_params or {
        offset = 0,
        scale = 1,
        spread = {x=64, y=64, z=64},
        seed = 952995,
        octaves = 2,
        persist = 0.5
    }

    opts.humidity_params = opts.humidity_params or {
        offset = 0,
        scale = 1,
        spread = {x=128, y=128, z=128},
        seed = 2946271,
        octaves = 2,
        persist = 0.5
    }

    local height_perlin, temperature_perlin, humidity_perlin

    -- [x .. "/" .. z] = @number
    local height_cache = {}
    local function get_height(mapblock_pos)
        local key = mapblock_pos.x .. "/" .. mapblock_pos.z
        if not height_cache[key] then
            height_perlin = height_perlin or minetest.get_perlin_map(opts.height_params, map_lengths_xyz)
            local height_perlin_map = {}
            height_perlin:get_2d_map_flat({x=mapblock_pos.x, y=mapblock_pos.z}, height_perlin_map)
            local height = math.floor(math.abs(height_perlin_map[1]) * 6) -1
            height_cache[key] = height
        end
        return height_cache[key]
    end

    -- [x .. "/" .. z] = @number
    local temperature_cache = {}
    local humidity_cache = {}
    local function get_temperature_humidity(mapblock_pos)
        local key = mapblock_pos.x .. "/" .. mapblock_pos.z
        if not temperature_cache[key] then
            temperature_perlin = temperature_perlin or minetest.get_perlin_map(opts.temperature_params, map_lengths_xyz)
            humidity_perlin = humidity_perlin or minetest.get_perlin_map(opts.humidity_params, map_lengths_xyz)

            local temperature_perlin_map = {}
            local humidity_perlin_map = {}

            temperature_perlin:get_2d_map_flat({x=mapblock_pos.x, y=mapblock_pos.z}, temperature_perlin_map)
            humidity_perlin:get_2d_map_flat({x=mapblock_pos.x, y=mapblock_pos.z}, humidity_perlin_map)

            local temperature = math.floor(math.abs(temperature_perlin_map[1]) * 100)
            local humidity = math.floor(math.abs(humidity_perlin_map[1]) * 100)

            temperature_cache[key] = temperature
            humidity_cache[key] = humidity
        end
        return temperature_cache[key], humidity_cache[key]
    end

    -- return a map with every lower-height blocks flagged
    local function get_height_map(mapblock_pos, height)
        local hm = {}
        for x=-1,1 do
            hm[x] = {}
            for z=-1,1 do
                hm[x][z] = get_height(vector.add(mapblock_pos, {x=x,y=0,z=z})) < height
            end
        end
        return hm
    end

    local function is_water(mapblock_pos)
        local height = get_height(mapblock_pos)
        return mapblock_pos.y == opts.water_level and height <= mapblock_pos.y
    end

    local function on_generated(minp, maxp)
        local min_mapblock = mapblock_lib.get_mapblock(minp)
        local max_mapblock = mapblock_lib.get_mapblock(maxp)

        if max_mapblock.y < opts.from_y or min_mapblock.y > opts.to_y then
            -- check broad y-range
            return
        end


        for x=min_mapblock.x,max_mapblock.x do
        for y=min_mapblock.y,max_mapblock.y do
        for z=min_mapblock.z,max_mapblock.z do
            if y < opts.from_y or y > opts.to_y then
                -- check exact y-range
                break
            end

            local mapblock_pos = { x=x, y=y, z=z }
            local height = get_height(mapblock_pos)

            local temperature, humidity = get_temperature_humidity(mapblock_pos)
            local biome = select_biome(opts.biomes, temperature, humidity)

            if is_water(mapblock_pos) then
                -- nothing above, place water building
                building_lib.build_mapgen(mapblock_pos, biome.buildings.water, 0)
            elseif mapblock_pos.y < height or mapblock_pos.y < opts.water_level then
                -- underground
                building_lib.build_mapgen(mapblock_pos, biome.buildings.underground, 0)
            elseif mapblock_pos.y == height then
                -- surface

                -- check if neighbors are lower
                local hm = get_height_map(mapblock_pos, height)

                local building_name = biome.buildings.surface
                local rotation = 0

                -- normal slopes
                if hm[-1][0] and not hm[1][0] and not hm[0][-1] and not hm[0][1] then
                    building_name = biome.buildings.slope
                    rotation = 90
                elseif not hm[-1][0] and hm[1][0] and not hm[0][-1] and not hm[0][1] then
                    building_name = biome.buildings.slope
                    rotation = 270
                elseif not hm[-1][0] and not hm[1][0] and hm[0][-1] and not hm[0][1] then
                    building_name = biome.buildings.slope
                    rotation = 0
                elseif not hm[-1][0] and not hm[1][0] and not hm[0][-1] and hm[0][1] then
                    building_name = biome.buildings.slope
                    rotation = 180
                -- outer slopes
                elseif hm[0][-1] and hm[-1][0] and not hm[0][1] and not hm[1][0] then
                    building_name = biome.buildings.slope_outer
                    rotation = 90
                elseif not hm[0][-1] and hm[-1][0] and hm[0][1] and not hm[1][0] then
                    building_name = biome.buildings.slope_outer
                    rotation = 180
                elseif not hm[0][-1] and not hm[-1][0] and hm[0][1] and hm[1][0] then
                    building_name = biome.buildings.slope_outer
                    rotation = 270
                elseif hm[0][-1] and not hm[-1][0] and not hm[0][1] and hm[1][0] then
                    building_name = biome.buildings.slope_outer
                    rotation = 0
                -- inner slopes
                elseif hm[-1][-1] and not hm[-1][1] and not hm[1][1] and not hm[1][-1] then
                    building_name = biome.buildings.slope_inner
                    rotation = 90
                elseif not hm[-1][-1] and hm[-1][1] and not hm[1][1] and not hm[1][-1] then
                    building_name = biome.buildings.slope_inner
                    rotation = 180
                elseif not hm[-1][-1] and not hm[-1][1] and hm[1][1] and not hm[1][-1] then
                    building_name = biome.buildings.slope_inner
                    rotation = 270
                elseif not hm[-1][-1] and not hm[-1][1] and not hm[1][1] and hm[1][-1] then
                    building_name = biome.buildings.slope_inner
                    rotation = 0
                end

                building_lib.build_mapgen(mapblock_pos, building_name, rotation)
            end
        end --z
        end --y
        end --x
    end

    return {
        on_generated = on_generated,
        get_height = get_height,
        get_temperature_humidity = get_temperature_humidity,
        get_biome = function(mapblock_pos)
            local temperature, humidity = get_temperature_humidity(mapblock_pos)
            return select_biome(opts.biomes, temperature, humidity)
        end,
        is_water = is_water
    }
end