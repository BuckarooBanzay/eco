local MP = minetest.get_modpath("eco_buildings")

local replacements = {
  {
    -- default
  },
  {
    -- aspen house
    ["default:pine_wood"] = "default:aspen_wood",
    ["default:pine_tree"] = "default:aspen_tree",
    ["default:brick"] = "moreblocks:cactus_brick",
    ["moreblocks:slope_brick"] = "moreblocks:slope_cactus_brick",
    ["moreblocks:slope_brick_outer"] = "moreblocks:slope_cactus_brick_outer",
    ["moreblocks:slope_brick_inner"] = "moreblocks:slope_cactus_brick_inner"
  },
  {
    -- acacia house
    ["default:pine_wood"] = "default:acacia_wood",
    ["default:pine_tree"] = "default:acacia_tree",
    ["default:brick"] = "moreblocks:grey_bricks"
  },
  {
    -- junglewood
    ["default:pine_wood"] = "default:junglewood",
    ["default:pine_tree"] = "default:jungletree",
    ["default:glass"] = "default:obsidian_glass"
  },
  {
    -- default wood
    ["default:pine_wood"] = "default:wood",
    ["default:pine_tree"] = "default:tree"
  }
}

eco_api.register_building({
  type = "building",
  key = "eco_buildings:simple_house_low_density",
  name = "Simple house with low density population",
  description = "Simple house with low density population",
  cost = 25000,
  schemas = {
    {
      directory = MP .. "/schematics/simple_house_low_density",
      replacements = replacements
    }
  },
})

eco_api.register_building({
  type = "building",
  key = "eco_buildings:simple_house_average_density",
  name = "Simple house with average density population",
  description = "Simple house with average density population",
  cost = 50000,
  schemas = {
    {
      directory = MP .. "/schematics/simple_house_average_density",
      replacements = replacements
    }
  }
})

eco_api.register_building({
  type = "building",
  key = "eco_buildings:simple_house_high_density",
  name = "Simple house with high density population",
  description = "Simple house with high density population",
  cost = 75000,
  influence = {
    noise = 1
  },
  schemas = {
    {
      directory = MP .. "/schematics/simple_house_high_density",
      replacements = replacements
    }
  }
})

eco_api.register_building({
  type = "building",
  key = "eco_buildings:simple_park",
  name = "Simple park",
  description = "Simple park with water and trees",
  cost = 120000,
  influence = {
    health = 3,
    noise = -1
  },
  size = {
    x = 2,
    z = 2
  },
  schemas = {
    {
      directory = MP .. "/schematics/simple_park",
      disable_rotation = true,
      replacements = {
        {},
        {
          -- sandstone
          ["default:stone_block"] = "default:desert_sandstone_block",
          ["moreblocks:slab_stonebrick"] = "moreblocks:slab_desert_sandstone_brick",
          ["default:bush_leaves"] = "default:acacia_bush_leaves",
          ["default:dirt_with_grass"] = "default:dirt_with_dry_grass",
          ["default:tree"] = "default:acacia_tree",
          ["default:leaves"] = "default:acacia_leaves"
        },
        {
          -- desert sandstone
          ["default:stone_block"] = "default:desert_stone_block",
          ["moreblocks:slab_stonebrick"] = "moreblocks:slab_desert_stonebrick",
          ["default:bush_leaves"] = "default:acacia_bush_leaves",
          ["default:dirt_with_grass"] = "default:dirt_with_dry_grass",
          ["default:tree"] = "default:acacia_tree",
          ["default:leaves"] = "default:acacia_leaves"
        },
        {
          -- silver sandstone
          ["default:stone_block"] = "default:silver_sandstone_block",
          ["moreblocks:slab_stonebrick"] = "moreblocks:slab_silver_sandstone_brick"
        }
      }
    }
  }
})

eco_api.register_building({
  type = "building",
  key = "eco_buildings:simple_school",
  name = "Simple school",
  description = "Simple school",
  cost = 150000,
  influence = {
    education = 2,
    noise = 1
  },
  schemas = {
    {
      directory = MP .. "/schematics/simple_school",
      replacements = {
        {},
        {
          ["default:brick"] = "moreblocks:cactus_brick",
          ["moreblocks:slope_brick"] = "moreblocks:slope_cactus_brick",
          ["moreblocks:slope_brick_outer"] = "moreblocks:slope_cactus_brick_outer",
          ["moreblocks:slope_brick_inner"] = "moreblocks:slope_cactus_brick_inner"
        }
      }
    }
  }
})
