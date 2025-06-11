data:extend({
  {
    type = "recipe",
    name = "irrigator-1",
    enabled = true,
    energy_required = 2,
    ingredients = {
      {type = "item", name = "pipe", amount = 10},
      {type = "item", name = "pipe-to-ground", amount = 5},
      {type = "item", name = "electronic-circuit", amount = 5},
    },
    results = {
      {type = "item", name = "irrigator-1", amount = 1}
    }
  },
    {
    type = "recipe",
    name = "irrigator-2",
    enabled = true,
    energy_required = 4,
    ingredients = {
      {type = "item", name = "irrigator-1", amount = 10},
      {type = "item", name = "advanced-circuit", amount = 5},
      {type = "item", name = "pipe-to-ground", amount = 5},
      {type = "item", name = "steel-plate", amount = 5},
    },
    results = {
      {type = "item", name = "irrigator-2", amount = 1}
    }
  },
    {
    type = "recipe",
    name = "irrigator-3",
    enabled = true,
    energy_required = 8,
    ingredients = {
      {type = "item", name = "irrigator-2", amount = 10},
      {type = "item", name = "processing-unit", amount = 2},
      {type = "item", name = "pipe-to-ground", amount = 5},
      {type = "item", name = "steel-plate", amount = 5},
    },
    results = {
      {type = "item", name = "irrigator-3", amount = 1}
    }
  },




  })

-- This code defines recipes for the Planeteers mod, including recipes for different levels of irrigators and compost/fertilizer production.

