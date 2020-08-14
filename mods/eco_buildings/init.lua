local MP = minetest.get_modpath("eco_buildings")

local replacements = {
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
  key = "eco_buildings:simple_house_high_density",
  name = "Simple house with high density population",
  description = "Simple house with high density population",
  cost = 75000,
  schemas = {
    {
      directory = MP .. "/schematics/simple_house_high_density",
      replacements = replacements
    }
  }
})
