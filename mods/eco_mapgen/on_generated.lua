
local map_lengths_xyz = {x=1, y=1, z=1}
local water_level = 0
local from_y = -5
local to_y = 10


local height_perlin, temperature_perlin, humidity_perlin

local init_perlin = Promise.once(function()
    height_perlin = core.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x=64, y=64, z=64},
        seed = 5477835,
        octaves = 2,
        persist = 0.5
    }, map_lengths_xyz)

    temperature_perlin = core.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x=64, y=64, z=64},
        seed = 952995,
        octaves = 2,
        persist = 0.5
    }, map_lengths_xyz)

    humidity_perlin = core.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x=128, y=128, z=128},
        seed = 2946271,
        octaves = 2,
        persist = 0.5
    }, map_lengths_xyz)
end)

-- [x .. "/" .. z] = @number
local height_cache = {}
local function get_height(mapblock_pos)
    local key = mapblock_pos.x .. "/" .. mapblock_pos.z
    if not height_cache[key] then
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
    return mapblock_pos.y == water_level and height <= mapblock_pos.y
end

local function select_template(temperature, humidity)
    local selected_score = -1
    local selected_template

    --[[
    for _, biome in ipairs(biomes) do
        local score = math.abs(temperature - biome.temperature) + math.abs(humidity - biome.humidity)
        if not selected_biome or score > selected_score then
            selected_biome = biome
            selected_score = score
        end
    end
    --]]

    return selected_template
end

local function get_template(mapblock_pos)
    local height = get_height(mapblock_pos)

    local temperature, humidity = get_temperature_humidity(mapblock_pos)
    local template = select_template(temperature, humidity)

    if is_water(mapblock_pos) then
        -- nothing above, place water building
        return template, "water", 0
    elseif mapblock_pos.y < height or mapblock_pos.y < water_level then
        -- underground
        return template, "underground", 0
    elseif mapblock_pos.y == height then
        -- surface

        -- check if neighbors are lower
        local hm = get_height_map(mapblock_pos, height)
        local partname = "surface"
        local rotation = 0

        -- normal slopes
        if hm[-1][0] and not hm[1][0] and not hm[0][-1] and not hm[0][1] then
            partname = "slope"
            rotation = 90
        elseif not hm[-1][0] and hm[1][0] and not hm[0][-1] and not hm[0][1] then
            partname = "slope"
            rotation = 270
        elseif not hm[-1][0] and not hm[1][0] and hm[0][-1] and not hm[0][1] then
            partname = "slope"
            rotation = 0
        elseif not hm[-1][0] and not hm[1][0] and not hm[0][-1] and hm[0][1] then
            partname = "slope"
            rotation = 180
        -- outer slopes
        elseif hm[0][-1] and hm[-1][0] and not hm[0][1] and not hm[1][0] then
            partname = "slope_outer"
            rotation = 90
        elseif not hm[0][-1] and hm[-1][0] and hm[0][1] and not hm[1][0] then
            partname = "slope_outer"
            rotation = 180
        elseif not hm[0][-1] and not hm[-1][0] and hm[0][1] and hm[1][0] then
            partname = "slope_outer"
            rotation = 270
        elseif hm[0][-1] and not hm[-1][0] and not hm[0][1] and hm[1][0] then
            partname = "slope_outer"
            rotation = 0
        -- inner slopes
        elseif hm[-1][-1] and not hm[-1][1] and not hm[1][1] and not hm[1][-1] then
            partname = "slope_inner"
            rotation = 90
        elseif not hm[-1][-1] and hm[-1][1] and not hm[1][1] and not hm[1][-1] then
            partname = "slope_inner"
            rotation = 180
        elseif not hm[-1][-1] and not hm[-1][1] and hm[1][1] and not hm[1][-1] then
            partname = "slope_inner"
            rotation = 270
        elseif not hm[-1][-1] and not hm[-1][1] and not hm[1][1] and hm[1][-1] then
            partname = "slope_inner"
            rotation = 0
        end

        return template, partname, rotation
    end
end

core.register_on_generated(function(minp, maxp)
    init_perlin()

    local min_mapblock = mapblock_lib.get_mapblock(minp)
    local max_mapblock = mapblock_lib.get_mapblock(maxp)

    if max_mapblock.y < from_y or min_mapblock.y > to_y then
        -- check broad y-range
        return
    end

    for x=min_mapblock.x,max_mapblock.x do
    for y=min_mapblock.y,max_mapblock.y do
    for z=min_mapblock.z,max_mapblock.z do
        if y < from_y or y > to_y then
            -- check exact y-range
            break
        end

        local mapblock_pos = { x=x, y=y, z=z }
        local template, partname, rotation = get_template(mapblock_pos)
        if template then
            template:place(mapblock_pos, {
                partname = partname,
                rotation = rotation
            })
        end
    end --z
    end --y
    end --x
end)

--[[
eco_mapgen.mapgen = building_lib.create_mapgen({
    biomes = {
        {
            name = "default",
            temperature = 40,
            humidity = 50,
            buildings = {
                underground = "eco_mapgen:terrain_underground",
                surface = "eco_mapgen:terrain_surface",
                slope = "eco_mapgen:terrain_slope",
                slope_inner = "eco_mapgen:terrain_slope_inner",
                slope_outer = "eco_mapgen:terrain_slope_outer",
                water = "eco_mapgen:water"
            }
        }
    },
    from_y = -5,
    to_y = 10,
    water_level = 0
})
--]]