-- control.lua

local terrain_success_chance = {
  ["grass-4"] = 0.99,
  ["grass-3"] = 0.96,
  ["grass-2"] = 0.95,
  ["grass-1"] = 0.94,
  ["dirt-1"]  = 0.85,
  ["dirt-2"]  = 0.84,
  ["dirt-3"]  = 0.83,
  ["dirt-4"]  = 0.8,
  ["dirt-5"]  = 0.79,
  ["dirt-6"]  = 0.78,
  ["dirt-7"]  = 0.77,
  ["landfill"]  = 0.6,
  ["dry-dirt"]  = 0.5,
  ["sand-1"]  = 0.42,
  ["sand-2"]  = 0.41,
  ["sand-3"]  = 0.4,
  ["red-desert-0"] = 0.01,
  ["red-desert-1"] = 0.005,
  ["red-desert-2"] = 0.003,
  ["red-desert-3"] = 0.002,
  ["nuclear-ground"] = 0.0001
}

local function get_random_seed_count()
  return math.random(1, 50)
end

script.on_event(defines.events.on_player_mined_entity, function(event)
  local entity = event.entity
  if entity and entity.type == "tree" then
    local player = game.get_player(event.player_index)
    if player then
      local count = get_random_seed_count()
      player.insert{name = "tree-seed", count = count}
      game.print("[Planeteers] Player received " .. count .. " tree seeds from mined tree.")
      rendering.draw_text{
        text = "+" .. count .. " seeds",
        surface = entity.surface,
        target = entity.position,
        color = {r = 0.3, g = 1, b = 0.3},
        time_to_live = 120,
        scale = 1.5
      }
    end
  end
end)

local function handle_tree_seed_placer(entity)
  local surface = entity.surface
  local position = entity.position
  local tile = surface.get_tile(position)
  local chance = terrain_success_chance[tile.name] or 0
  game.print("[Planeteers] Tree seed on terrain '" .. tile.name .. "' has spawn chance: " .. chance)
  if math.random() >= chance then
    game.print("[Planeteers] Seed failed to grow at (" .. position.x .. ", " .. position.y .. ")")
    entity.destroy()
    return
  end

  local trees = {"tree-01", "tree-02", "tree-03", "tree-04", "tree-05", "tree-06", "tree-07", "tree-08", "tree-09"}
  local tree = trees[math.random(#trees)]
  local spawn_pos = surface.find_non_colliding_position(tree, position, 2, 0.5) or position
  surface.create_entity{name = tree, position = spawn_pos, force = "neutral"}
  game.print("[Planeteers] Tree '" .. tree .. "' planted successfully at (" .. spawn_pos.x .. ", " .. spawn_pos.y .. ")")
  entity.destroy()
end

script.on_event(defines.events.on_built_entity, function(event)
  local entity = event.created_entity or event.entity
  if not (entity and entity.valid) then return end

  if entity.name == "planeteers-tree-seed-placer" then
    handle_tree_seed_placer(entity)
  elseif entity.name:match("^irrigator%-%d$") then
    global.irrigators = global.irrigators or {}
    table.insert(global.irrigators, entity)
    game.print("[Planeteers] " .. entity.name .. " placed at (" .. entity.position.x .. ", " .. entity.position.y .. ")")
  end
end)

---------------------- irrigator -----------------------

local TILE_UPGRADE_CHAIN = {
  ["red-desert-3"] = "red-desert-2",
  ["red-desert-2"] = "red-desert-1",
  ["red-desert-1"] = "red-desert-0",
  ["red-desert-0"] = "sand-3",
  ["sand-3"] = "sand-2",
  ["sand-2"] = "sand-1",
  ["sand-1"] = "dry-dirt",
  ["dry-dirt"] = "dirt-7",
  ["dirt-7"] = "dirt-6",
  ["dirt-6"] = "dirt-5",
  ["dirt-5"] = "dirt-4",
  ["dirt-4"] = "dirt-3",
  ["dirt-3"] = "dirt-2",
  ["dirt-2"] = "dirt-1",
  ["dirt-1"] = "grass-1",
  ["grass-1"] = "grass-2",
  ["grass-2"] = "grass-3",
  ["grass-3"] = "grass-4",
  ["landfill"] = "dirt-7"
}

if not global then global = {} end

script.on_init(function()
  global.irrigators = {}
  global.hydration_scores = {}
end)

script.on_configuration_changed(function()
  global.irrigators = global.irrigators or {}
  global.hydration_scores = global.hydration_scores or {}
end)

local PROCESS_INTERVAL_TICKS = 1
local CHECK_IDLE_INTERVAL_TICKS = 3600
local irrigator_index = 1

local function get_area_radius_by_irrigator(irrigator_name)
  if irrigator_name == "irrigator-1" then return 16
  elseif irrigator_name == "irrigator-2" then return 32
  elseif irrigator_name == "irrigator-3" then return 48
  else return 16
  end
end

script.on_event(defines.events.on_tick, function(event)
  if event.tick % PROCESS_INTERVAL_TICKS == 0 then
    if #global.irrigators == 0 then return end

    irrigator_index = (irrigator_index % #global.irrigators) + 1
    local irrigator = global.irrigators[irrigator_index]
    if not irrigator.valid then
      table.remove(global.irrigators, irrigator_index)
      return
    end

    local fluid = irrigator.fluidbox and irrigator.fluidbox[1]
    if not (fluid and fluid.name == "water" and fluid.amount >= 1) then
      game.print("[Planeteers] Irrigator at (" .. irrigator.position.x .. ", " .. irrigator.position.y .. ") lacks water.")
      return
    end

    irrigator.fluidbox[1] = {
      name = "water",
      amount = fluid.amount,
      temperature = fluid.temperature or 15
    }

    local radius = get_area_radius_by_irrigator(irrigator.name)
    local surface = irrigator.surface
    local origin = irrigator.position
    local surface_index = surface.index
    global.hydration_scores[surface_index] = global.hydration_scores[surface_index] or {}
    local scores = global.hydration_scores[surface_index]

    for i = 1, 5 do
      local dx = math.random(-radius, radius - 1)
      local dy = math.random(-radius, radius - 1)
      local x, y = math.floor(origin.x + dx), math.floor(origin.y + dy)
      local pos = {x = x + 0.5, y = y + 0.5}
      local tile = surface.get_tile(pos)
      local current_tile = tile.name

      if current_tile == "grass-4" then
        game.print("[Planeteers] Skipping max-upgrade tile at (" .. pos.x .. ", " .. pos.y .. ")")
      else
        local next_tile = TILE_UPGRADE_CHAIN[current_tile]
        if next_tile then
          local prob = terrain_success_chance[next_tile] or 0.001
          local threshold = math.floor((1 - prob + 0.01) * 10)
          local key = x .. "," .. y
          scores[key] = (scores[key] or 0) + 1
          if scores[key] >= threshold then
            surface.set_tiles{{name = next_tile, position = pos}}
            scores[key] = 0
            game.print("[Planeteers] Tile upgraded to " .. next_tile .. " at (" .. pos.x .. ", " .. pos.y .. ")")
          end
        end
      end
    end
  end

  -- Idle check once per minute (85% grass-4 in area excluding cliffs/water)
  if event.tick % CHECK_IDLE_INTERVAL_TICKS == 0 then
    local active_irrigators = {}
    for _, irrigator in ipairs(global.irrigators) do
      if irrigator.valid then
        local radius = get_area_radius_by_irrigator(irrigator.name)
        local surface = irrigator.surface
        local origin = irrigator.position

        local total_checked = 0
        local total_valid = 0
        local total_grass4 = 0

        for i = 1, math.floor(radius * radius * 4 * 0.85) do
          local dx = math.random(-radius, radius - 1)
          local dy = math.random(-radius, radius - 1)
          local pos = {x = origin.x + dx + 0.5, y = origin.y + dy + 0.5}
          local tile = surface.get_tile(pos)
          local name = tile.name
          if not name:find("water") and not name:find("cliff") then
            total_valid = total_valid + 1
            if name == "grass-4" then
              total_grass4 = total_grass4 + 1
            end
          end
          total_checked = total_checked + 1
        end

        local ratio = total_grass4 / math.max(total_valid, 1)
        if ratio >= 0.85 then
          game.print("[Planeteers] Removing idle " .. irrigator.name .. " at (" .. origin.x .. ", " .. origin.y .. ")")
          irrigator.destroy()
        else
          table.insert(active_irrigators, irrigator)
        end
      end
    end
    global.irrigators = active_irrigators
  end
end)
