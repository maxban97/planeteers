data:extend({
  {
    type = "item",
    name = "tree-seed",
    icon = "__Planeteers__/graphics/icons/tree-seed.png",
    icon_size = 128,
    subgroup = "raw-material",
    order = "a[tree-seed]",
    stack_size = 200,
    place_result = "planeteers-tree-seed-placer"
  },
  {
    type = "simple-entity",
    name = "planeteers-tree-seed-placer",
    icon = "__Planeteers__/graphics/icons/tree-seed.png",
    icon_size = 128,
    flags = {"placeable-neutral", "player-creation", "not-on-map"},
    selectable_in_game = false,
    collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    picture = {
      filename = "__core__/graphics/empty.png",
      width = 1,
      height = 1
    },
    render_layer = "object",
    minable = {mining_time = 0.1, result = nil},
    max_health = 1
  }
})


data:extend({
  {
    type = "item",
    name = "irrigator-1",
    icon = "__Planeteers__/graphics/icons/irrigator-1-icon.png",
    icon_size = 256,
    subgroup = "production-machine",
    order = "b[fluid]-a[irrigator-1]",
    place_result = "irrigator-1",
    stack_size = 50
  },
  {
    type = "item",
    name = "irrigator-2",
    icon = "__Planeteers__/graphics/icons/irrigator-2-icon.png",
    icon_size = 1024,
    subgroup = "production-machine",
    order = "b[fluid]-b[irrigator-2]",
    place_result = "irrigator-2",
    stack_size = 50
  },
  {
    type = "item",
    name = "irrigator-3",
    icon = "__Planeteers__/graphics/icons/irrigator-3-icon.png",
    icon_size = 64,
    subgroup = "production-machine",
    order = "b[fluid]-c[irrigator-3]",
    place_result = "irrigator-3",
    stack_size = 50
  }
})
