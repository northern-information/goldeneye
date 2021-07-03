samples = {}

function samples.init()
  samples.id_prefix = "id"
  samples.id_counter = 0
  samples.selected = 1
  samples.selected_x = 1
  samples.selected_y = 1
  samples.all = {}
  for x = 1, _grid:get_width() do
    for y = 1, _grid:get_height() do
      local s = Sample:new(x, y)
      samples.all[s.index] = s
    end
  end
end

function samples:get_selected()
  return self:get(self.selected)
end

function samples:get_selected_x()
  return self.selected_x
end

function samples:get_selected_y()
  return self.selected_y
end

function samples:get(index)
  return self.all[index]
end

function samples:get_all()
  return self.all
end

function samples:toggle(x, y)
  local s = self:get(self:index(x, y))
  s:toggle()
end

function samples:select_x(x)
  self.selected_x = x
  self:select(self:index(self.selected_x, self.selected_y))
end

function samples:select_y(y)
  self.selected_y = y
  self:select(self:index(self.selected_x, self.selected_y))
end

function samples:select(index)
  self.selected = index
end

function samples:index(x, y)
  return x + ((y - 1) * _grid:get_width())
end

function samples:id()
  self.id_counter = self.id_counter + 1
  return self.id_prefix .. os.time(os.date("!*t")) .. "-" .. self.id_counter
end

return samples