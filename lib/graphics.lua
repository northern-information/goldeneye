local graphics = {}

function graphics.init()
  screen.aa(0)
  screen.font_face(0)
  screen.font_size(8)
  graphics.screen_dirty = true
  graphics.max_width = 128
  graphics.max_height = 64
  graphics.fps = 15
  graphics.message = "GOLDENEYE!"
end

function graphics:set_message(s)
  self.message = s
end

function graphics:sample()
  local sample = samples:get_selected()
  self:text(0, 10, sample:get_name())
  self:text(0, 20, "X: " .. sample:get_x())
  self:text(0, 30, "Y: " .. sample:get_y())
  self:text(0, 40, "INDEX: " .. sample:get_index())
  local p = "NOT PLAYING"
  if sample:is_playing() then p = "PLAYING" end
  self:text(0, 50, p)
  self:text(0, 60, "VOLUME: " .. sample:get_volume())
end

-- northern information
-- graphics library

function graphics:setup()
  screen.clear()
end

function graphics:teardown()
  screen.update()
end

function graphics:mlrs(x1, y1, x2, y2, l)
  screen.level(l or 15)
  screen.move(x1, y1)
  screen.line_rel(x2, y2)
  screen.stroke()
end

function graphics:mls(x1, y1, x2, y2, l)
  screen.level(l or 15)
  screen.move(x1, y1)
  screen.line(x2, y2)
  screen.stroke()
end

function graphics:rect(x, y, w, h, l)
  screen.level(l or 15)
  screen.rect(x, y, w, h)
  screen.fill()
end

function graphics:circle(x, y, r, l)
  screen.level(l or 15)
  screen.circle(x, y, r)
  screen.fill()
end

function graphics:text(x, y, s, l)
  screen.level(l or 15)
  screen.move(x, y)
  screen.text(s)
end

function graphics:text_right(x, y, s, l)
  screen.level(l or 15)
  screen.move(x, y)
  screen.text_right(s)
end

function graphics:text_center(x, y, s, l)
  screen.level(l or 15)
  screen.move(x, y)
  screen.text_center(s)
end

return graphics