-- ........,,..................,,,......,...,...................,,,,
-- ...,,...,,...........,......,....................,............,,,
-- ..........,,.......,.....,...,.....,......,,...................,,
-- ......................,,,....,............,,,....,,......,,,,,,,,
-- ........,,...........,,.,..................,,.......,,,..........
-- .............,..........,..........,..........,,...........,,,,,,
-- ......................,,,....,...................,,........,,,,,,
-- ....................................,,,....................,,,,,,

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
  grid_dirty, screen_dirty, splash_break = true, true, false
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
  fn.break_splash(true)
  local s = samples:get_selected()
  local row = "row" .. s:get_y()
  if e == 1 then
    if _grid:is_long_press() then  
      s:set_volume(util.clamp(s:get_volume() + d, 0, 100))
    else
      if d > 0 then
        samples:toggle_random()
      elseif d < 0 then
        samples:untoggle_last()
      end
      fn.dirty_grid(true)  
    end
  elseif e == 2 then
    if _grid:is_long_press() then
      s:set_density(util.clamp(s:get_density() + d, config.min_density[row], config.max_density[row]))
    else
      samples:select_x(util.clamp(samples:get_selected_x() + d, 1, _grid:get_width()))
    end
  elseif e == 3 then
    if _grid:is_long_press() then
      s:set_length(util.clamp(s:get_length() + d, config.min_length[row], config.max_length[row]))
    else
      samples:select_y(util.clamp(samples:get_selected_y() + d, 1, _grid:get_height()))
    end
  end
 fn.dirty_screen(true)
end

function key(k, z)
  fn.break_splash(true)
  if z == 1 then return end
  if k == 1 then 
    -- emulate grid toggle
    local s = samples:get_selected()
    _grid:short_press(s:get_x(),s:get_y())
  elseif k == 2 then
    golden_lattice:toggle()
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