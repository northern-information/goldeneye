samples = {}

function samples.init()
  samples.id_prefix = "id"
  samples.id_counter = 0
  samples.steps = 16
  samples.step = 0
  samples.selected = 1
  samples.selected_x = 1
  samples.selected_y = 1
  samples.all = {}
  samples.toggled = {} -- running list of toggled samples (in order)
  for x = 1, _grid:get_width() do
    for y = 1, _grid:get_height() do
      local s = Sample:new(x, y)
      samples.all[s.index] = s
    end
  end
end

function samples:play()
  self:increment_step()
  for k, s in pairs(self:get_all()) do
    if self:get_step() % s:get_speed() == 0 then
      s:increment_pointer()
      if s:is_playing() and s:get_er()[s:get_pointer()] then
        s:trigger()
      end
    end
  end
end

function samples:irradiate()
  for k, s in pairs(self:get_all()) do
    s:irradiate()
  end
end

function samples:set_steps(i)
  self.steps = i
end

function samples:get_steps()
  return self.steps
end

function samples:get_step()
  return self.step
end

function samples:increment_step()
  self.step = util.wrap(self.step + 1, 1, self:get_steps())
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

function samples:toggle_random()
  -- try to find a empty slot
  -- yes this is lazy...
  for i=1,100 do
    local x = math.random(1,16)
    local y = math.random(1,8)
    if not self:is_toggled(x,y) then
      self:toggle(x,y)
      break
    end
  end
end

function samples:untoggle_last()
  -- pop last toggled and untoggle it
  local v = table.remove(self.toggled)
  if v ~= nil then
    self:toggle(v.x,v.y)
  end
end

function samples:toggle(x, y)
  local s = self:get(self:index(x, y))
  self:update_toggled(x,y,s:toggle())
end

function samples:is_toggled(x,y)
  local s = self:get(self:index(x, y))
  return s:is_playing()
end

function samples:update_toggled(x,y,on)
  if on then 
    table.insert(self.toggled,{x=x,y=y})
  else
    for i,v in ipairs(self.toggled) do
      if v.x==x and v.y==y then
        table.remove(self.toggled,i)
        break
      end
    end
  end
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