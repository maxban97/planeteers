
-- entity.lua

local function four_pipe_connections(radius)
  local r = radius or 0.5
  return {
    { position = { 0, -r } , direction = defines.direction.north}, -- north
    { position = { 0,  r } , direction = defines.direction.south}, -- south
    { position = {-r,  0 } , direction = defines.direction.west}, -- west
    { position = { r,  0 } , direction = defines.direction.east}, -- east
  }
end

data:extend({
  {
    type = "storage-tank",
    name = "irrigator-1",
    icon = "__Planeteers__/graphics/icons/irrigator-1-icon.png",
    icon_size = 64,
    flags = {"placeable-player", "player-creation"},
    minable = {mining_time = 0.5, result = "irrigator-1"},
    max_health = 200,
    corpse = "small-remnants",
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    fluid_box = {
      base_area = 1,
      height = 1,
      volume = 1,
      pipe_covers = pipecoverspictures(),
      pipe_connections = four_pipe_connections(0-0.1),
      type = "input-output",
      filter = "water"
    },
    window_bounding_box = {{0, 0}, {0, 0}},
    pictures = {
      picture = {
        filename = "__Planeteers__/graphics/entity/irrigator-1.png",
        priority = "extra-high",
        width = 128,
        height = 128,
        scale = 0.25,
        shift = {0, 0},
        -- tint = {r = 0.5, g = 1.0, b = 0.5, a = 1.0}
      }
    },
    flow_length_in_ticks = 360,
    circuit_wire_max_distance = 0
  },

  {
    type = "storage-tank",
    name = "irrigator-2",
    icon = "__Planeteers__/graphics/icons/irrigator-2-icon.png",
    icon_size = 64,
    flags = {"placeable-player", "player-creation"},
    minable = {mining_time = 0.5, result = "irrigator-2"},
    max_health = 300,
    corpse = "small-remnants",
    collision_box = {{-1.5, -1.5}, {1.5, 1.5}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    energy_required = 2,
    energy_source = {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = 0.1
      },  
    energy_usage = "30kW",

    fluid_box = {
      base_area = 1,
      height = 1,
      volume = 1,
      pipe_covers = pipecoverspictures(),
      pipe_connections = four_pipe_connections(1-0.1),
      type = "input-output",
      filter = "water"
    },
    window_bounding_box = {{0, 0}, {0, 0}},
    pictures = {
      picture = {
        filename = "__Planeteers__/graphics/entity/irrigator-2.png",
        priority = "extra-high",

        width = 1024,
        height = 1024,
        scale = 0.25,
        shift = {0, 0},
        -- tint = {r = 0.4, g = 0.9, b = 0.4, a = 1.0}
      }
    },
    flow_length_in_ticks = 360,
    circuit_wire_max_distance = 0
  },

  {
    type = "storage-tank",
    name = "irrigator-3",
    icon = "__Planeteers__/graphics/icons/irrigator-3-icon.png",
    icon_size = 64,
    flags = {"placeable-player", "player-creation"},
    minable = {mining_time = 0.5, result = "irrigator-3"},
    max_health = 400,
    corpse = "small-remnants",
    collision_box = {{-2.5, -2.5}, {2.5, 2.5}},
    selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
    fluid_box = {
      base_area = 1,
      height = 1,
      volume = 1,
      pipe_covers = pipecoverspictures(),
      pipe_connections = four_pipe_connections(2-0.1),
      type = "input-output",
      filter = "water"
    },
    window_bounding_box = {{0, 0}, {0, 0}},
    pictures = {
      picture = {
        filename = "__Planeteers__/graphics/entity/irrigator-3.png",
        priority = "extra-high",
        width = 640,
        height = 640,
        scale = 0.25,
        shift = {0, 0},
        -- tint = {r = 0.3, g = 0.8, b = 0.3, a = 1.0}
      }
    },
    flow_length_in_ticks = 360,
    circuit_wire_max_distance = 0
  }
})
