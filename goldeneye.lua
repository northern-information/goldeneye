engine.name = "Goldeneye"
lattice = require("lattice")
er = require("er")
include("lib/Sample")
config = include("lib/config")
_grid = include("lib/_grid")
fn = include("lib/functions")
filesystem = include("lib/filesystem")
samples = include("lib/samples")
graphics = include("lib/graphics")

function init()
  graphics.init()
  _grid.init()
  filesystem.init()
  samples.init()
  samples:select_x(1)
  samples:select_y(1)
  golden_lattice = lattice:new()
  p = golden_lattice:new_pattern{
    action = function(t) samples:play() end,
    division = 1/16,
    enabled = true
  }
  golden_lattice:start()
  grid_clock_id = clock.run(_grid.grid_redraw_clock)
  frame_clock_id = clock.run(graphics.frame_clock)
  redraw_clock_id = clock.run(redraw_clock)
end

function enc(e, d)
  if e == 1 then
    if _grid:is_long_press() then
      local s = samples:get_selected()
      s:set_volume(util.clamp(s:get_volume() + d, 0, 100))
    end
  elseif e == 2 then
    samples:select_x(util.clamp(samples:get_selected_x() + d, 1, _grid.last_known_width))
  elseif e == 3 then
    samples:select_y(util.clamp(samples:get_selected_y() + d, 1, _grid.last_known_height))
  end
 fn.dirty_screen(true)
end

function key(k, z)
  if z == 1 then return end
  if k == 2 then
    l:toggle()
  elseif k == 3 then
    if _grid:is_long_press() then
      samples:get_selected():irradiate()
    else
      samples:irradiate()
    end
  end
  fn.dirty_screen(true)
end

function redraw_clock()
  while true do
    if fn.dirty_screen()then
      redraw()
      fn.dirty_screen(false)
    end
    clock.sleep(1 / graphics.fps)
  end
end

function redraw()
  graphics:render()
end