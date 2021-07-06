local graphics = {}

function graphics.init()
  graphics.screen_dirty = true
  graphics.fps = 15
  graphics.message = "GOLDENEYE!"
  graphics.frame_number = 0
  graphics.stars = {}
  graphics.stars_count = 16
  graphics.horizon = 46
  graphics.analysis_pixels = {}
  graphics.splash_lines_open = {}
  graphics.splash_lines_close = {}
  graphics.splash_lines_close_available = {}
  for i=1,45 do graphics.splash_lines_open[i] = i end
  for i=1,64 do graphics.splash_lines_close_available[i] = i end
end

function graphics:set_message(s)
  self.message = s
end

function graphics:draw_numbers()
  local s = samples:get_selected()
  self:text_center(64, 21, "(" .. s:get_density() .. "," .. s:get_length() .. "," ..  s:get_offset() .. "," .. s:get_volume() .. ")", 5)
  self:serif_font()
  self:text_center(16, 21, s:get_x(), 5)
  self:text_center(112, 21, s:get_y(), 5)
  self:sans_serif_font()
end

function graphics:sequence()
  local pointer = samples:get_selected():get_pointer()
  local er = samples:get_selected():get_er()
  local display = ""
  local step = 1
  for k, v in pairs(er) do
    if pointer == step then
      display = display .. "!"
    elseif v then
      display = display .. "x"
    else
      display = display .. "-"
    end
    step = step + 1
  end
  self:text_center(64, 30, display, 5)
end

function graphics:sample()
  local sample = samples:get_selected()
  self:text_center(64, 40, sample:get_name(), 5)
end

function graphics:render()
  self:setup()
  if fn.break_splash() then
    self:draw_horizon()
    self:draw_stars()
    self:draw_stage()
    self:draw_numbers()
    self:sample()
    self:sequence()
  else
    self:splash()
  end
  self:teardown()
end

function graphics:draw_horizon()
  local l = 1
  local h = self.horizon
  self:mlrs(0, h, 128, 0, l)
  self:mlrs(0, h + 3, 128, 0, l)
  self:mlrs(0, h + 8, 128, 0, l)
  self:mls(54, h, 44, 64, l)
  self:mls(44, h, 24, 64, l)
  self:mls(34, h, 4, 64, l)
  self:mls(24, h, -14, 64, l)
  self:mls(14, h, -34, 64, l)
  self:mls(74, h, 84, 64, l)
  self:mls(84, h, 104, 64, l)
  self:mls(94, h, 124, 64, l)
  self:mls(104, h, 144, 64, l)
  self:mls(114, h, 164, 64, l)
end

function graphics:text_center(x, y, s, l)
  screen.level(l or 15)
  screen.move(x, y)
  screen.text_center(s)
end

function graphics:draw_stage()
  -- roof
  self:rect_mirror(0, 0, 64, 2, 15)
  self:rect_mirror(0, 0, 50, 5, 15)
  -- columns
  self:rect_mirror(0, 58, 16, 2, 15)
  self:rect_mirror(0, 60, 24, 4, 15)
  self:rect_mirror(2, 0, 2, 58, 4)
  self:rect_mirror(6, 0, 2, 58, 10)
  -- left cirlce
  self:circle(16, 16, 16, 15)
  self:circle(16, 16, 13, 0)  
  -- right cirlce
  self:circle(112, 16, 16, 15)
  self:circle(112, 16, 13, 0)
  -- bubbles
  self:bubble_mirror(35, 8, 7, 3)
  self:bubble_mirror(32, 3, 3, 0)
  self:bubble_mirror(28, 5, 3, 0)
  self:bubble_mirror(3, 3, 9, 3)
  self:bubble_mirror(4, 4, 3, 0)
  self:bubble_mirror(3, 50, 3, 0)
  self:bubble_mirror(10, 60, 3, 0)
end

function graphics:bubble_mirror(x, y, r, l)
  self:circle(x, y, r, 15)
  self:circle(x, y, r-1, l)
  self:circle(128-x, y, r, 15)
  self:circle(128-x, y, r-1, l)
end

function graphics:rect_mirror(x, y, w, h, l)
  self:rect(x, y, w, h, l)
  self:rect(128-x-w, y, w, h, l)
end

function graphics:draw_stars()
  for k, v in pairs(self.stars) do
    self:sp(v.x, v.y, v.l)
  end
end

function graphics:make_stars()
  self.stars = {}
  for i = 1, self.stars_count do
    table.insert(self.stars, {x = math.random(0, 128), y = math.random(0, self.horizon), l = 1}) 
  end
end


-- entropy rectangle
function graphics:er(x, y, w, h, e, l)
  for x = x, x + w do
    for y = y, y + h do
      self:ep(x, y, e, l)
    end
  end
end

-- vertical entropy line
function graphics:vel(x1, y1, y2, e, l)
  if y1 < y2 then
    for i = y1, y2 do self:ep(x1, i, e, l) end
  else
    for i = y2, y1 do self:ep(x1, i, e, l) end
  end
end

-- horizontal entropy line
function graphics:hel(y1, x1, x2, e, l)
  if x1 < x2 then
    for i = x1, x2 do self:ep(i, y1, e, l) end
  else
    for i = x2, x1 do self:ep(i, y1, e, l) end
  end
end


-- entropy pixel
function graphics:ep(x, y, e, l)
  local rx, ry = math.random(0, e), 0
  if rx == 0 then
    ry = math.random(0, e)
  end
  self:sp(x + rx, y + ry, l)
end

-- static pixel
function graphics:sp(x, y, l)
  screen.level(l or 15)
  screen.move(x, y)
  screen.line(x - 1, y - 1)
  screen.stroke(s)
end

function graphics:setup()
  screen.clear()
  screen.aa(0)
  self:sans_serif_font()
end

function graphics:sans_serif_font()
  screen.aa(0)
  screen.font_face(0)
  screen.font_size(8)
end

function graphics:serif_font()
  screen.aa(0)
  screen.font_face(62)
  screen.font_size(8)
end

function graphics:teardown()
  screen.update()
end

function graphics:mlrs(x1, y1, x2, y2, level)
  screen.level(level or 15)
  screen.move(x1, y1)
  screen.line_rel(x2, y2)
  screen.stroke()
end

function graphics:mls(x1, y1, x2, y2, level)
  screen.level(level or 15)
  screen.move(x1, y1)
  screen.line(x2, y2)
  screen.stroke()
end

function graphics:rect(x, y, w, h, level)
  screen.level(level or 15)
  screen.rect(x, y, w, h)
  screen.fill()
end

function graphics:circle(x, y, r, level)
  screen.level(level or 15)
  screen.circle(x, y, r)
  screen.fill()
end

function graphics:text(x, y, s, level)
  if s == nil then return end
  screen.level(level or 15)
  screen.move(x, y)
  screen.text(s)
end

function graphics.frame_clock()
  while true do
    graphics.frame_number = graphics.frame_number + 1
    if graphics.frame_number % 2 == 0 then
      graphics:make_stars()
    end
    fn.dirty_screen(true)
    clock.sleep(1 / graphics.fps)
  end
end

function graphics:splash()
  local col_x = 34
  local row_x = 34
  local y = 45
  local l = self.frame_number >= 49 and 0 or 15
  if self.frame_number >= 49 then
    self:rect(0, 0, 128, 50, 15)
  end
  self:ni(col_x, row_x, y, l)
  if #self.splash_lines_open > 1 then 
    local delete = math.random(1, #self.splash_lines_open)
    table.remove(self.splash_lines_open, delete)
    for i = 1, #self.splash_lines_open do
      self:mlrs(1, self.splash_lines_open[i] + 4, 128, 1, 0)
    end
  end
  if self.frame_number >= 49 then
    self:text_center(64, 60, "NORTHERN INFORMATION")
  end
  if self.frame_number > 100 then
    if #self.splash_lines_close_available > 0 then 
      local add = math.random(1, #self.splash_lines_close_available)
      table.insert(self.splash_lines_close, self.splash_lines_close_available[add])
      table.remove(self.splash_lines_close_available, add)
    end
    for i = 1, #self.splash_lines_close do
      self:mlrs(1, self.splash_lines_close[i], 128, 1, 0)
    end
  end
  if #self.splash_lines_close_available == 0 then
    fn.break_splash(true)
  end
  fn.dirty_screen(true)
end

function graphics:ni(col_x, row_x, y, l)
  self:n_col(col_x, y, l)
  self:n_col(col_x+20, y, l)
  self:n_col(col_x+40, y, l)
  self:n_row_top(row_x, y, l)
  self:n_row_top(row_x+20, y, l)
  self:n_row_top(row_x+40, y, l)
  self:n_row_bottom(row_x+9, y+37, l)
  self:n_row_bottom(row_x+29, y+37, l)
end

function graphics:n_col(x, y, l)
  self:mls(x, y, x+12, y-40, l)
  self:mls(x+1, y, x+13, y-40, l)
  self:mls(x+2, y, x+14, y-40, l)
  self:mls(x+3, y, x+15, y-40, l)
  self:mls(x+4, y, x+16, y-40, l)
  self:mls(x+5, y, x+17, y-40, l)
end

function graphics:n_row_top(x, y, l)
  self:mls(x+20, y-39, x+28, y-39, l)
  self:mls(x+20, y-38, x+28, y-38, l)
  self:mls(x+19, y-37, x+27, y-37, l)
  self:mls(x+19, y-36, x+27, y-36, l)
end

function graphics:n_row_bottom(x, y, l)
  self:mls(x+21, y-40, x+29, y-40, l)
  self:mls(x+21, y-39, x+29, y-39, l)
  self:mls(x+20, y-38, x+28, y-38, l)
  self:mls(x+20, y-37, x+28, y-37, l)
end

return graphics