_grid = {}
g = grid.connect()

function _grid.init()
  _grid.long_press = false
  _grid.counter = {}
  _grid.last_known_width = g.cols
  _grid.last_known_height = g.rows
  for x = 1, _grid.last_known_width do
    _grid.counter[x] = {}
    for y = 1, _grid.last_known_height do
      _grid.counter[x][y] = nil
    end
  end
  fn.dirty_grid(true)
end

function g.key(x, y, z)
  graphics:set_message(x, y, z)
  fn.dirty_screen(true)
  if z == 1 then
    _grid.counter[x][y] = clock.run(_grid.grid_long_press, g, x, y)
  end
  if z == 0 then -- otherwise, if a grid key is released...
    if _grid.counter[x][y] then -- and the long press is still waiting...
      clock.cancel(_grid.counter[x][y]) -- then cancel the long press clock,
      _grid:short_press(x,y) -- and execute a short press instead.
    end
    _grid:set_long_press(false)
  end
end

function _grid:short_press(x, y)
  samples:select_x(x)
  samples:select_y(y)
  samples:toggle(x, y)
  fn.dirty_grid(true)
  fn.dirty_screen(true)
end

function _grid:is_long_press()
  return self.long_press
end

function _grid:grid_long_press(x, y)
  clock.sleep(.5)
  _grid:set_long_press(true)
  samples:select_x(x)
  samples:select_y(y)
  _grid.counter[x][y] = nil
  fn.dirty_grid(true)  
  fn.dirty_screen(true)
end

function _grid.grid_redraw_clock()
  while true do
    clock.sleep(1 / 30)
    if fn.dirty_grid() == true then
      _grid:grid_redraw()
      fn.dirty_grid(false)
    end
  end
end

function _grid:draw_live_samples()
  for k, sample in pairs(samples:get_all()) do
    if sample:is_live() then
      g:led(sample:get_x(), sample:get_y(), 1)
    end
  end
end

function _grid:draw_playing_samples()
  for k, sample in pairs(samples:get_all()) do
    if sample:is_playing() then
      g:led(sample:get_x(), sample:get_y(), 15)
    end
  end
end

function _grid:grid_redraw()
  g:all(0)
  self:draw_live_samples()
  self:draw_playing_samples()
  g:refresh()
end

function _grid:get_width()
  return _grid.last_known_width
end

function _grid:get_height()
  return _grid.last_known_height
end

function _grid:set_long_press(bool)
  self.long_press = bool
end

return _grid