local graphics = {}

function graphics.init()
  graphics.screen_dirty = true
  graphics.fps = 15
  graphics.message = "GOLDENEYE!"
  graphics.frame_number = 0
  graphics.stars = {}
  graphics.stars_count = 16
  graphics.horizon = 46
end

function graphics:set_message(s)
  self.message = s
end

function graphics:sample()
  local sample = samples:get_selected()
  self:text_center(64, 40, sample:get_name())
  local p = "NOT PLAYING"
  if sample:is_playing() then p = "PLAYING" end
  self:text_center(64, 50, p)
  self:text_center(64, 60, "VOLUME: " .. sample:get_volume())
end


function graphics:render()
  self:setup()
  self:draw_horizon()
  self:draw_stars()
  self:draw_stage()
  self:draw_numbers()
  self:sample()
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

function graphics:draw_numbers()
  local s = samples:get_selected()
  self:text_center(64, 21, "(" .. s:get_density() .. "," .. s:get_length() .. "," ..  s:get_offset() .. ")", 5)
  self:serif_font()
  self:text_center(16, 21, s:get_x(), 5)
  self:text_center(112, 21, s:get_y(), 5)
  self:sans_serif_font()
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

return graphics