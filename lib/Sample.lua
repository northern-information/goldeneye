Sample = {}

function Sample:new(x, y)
  local s = setmetatable({}, { __index = Sample })
  s.x = x
  s.y = y
  s.id = "sample-" .. samples:id()  -- unique identifier for this sample
  s.index = samples:index(x, y) -- location on the grid
  s.speed = 4
  s.pointer = 1
  s.density = 0
  s.length = 0
  s.offset = 0
  s.er = {}
  s:irradiate()
  local name = filesystem:get_sample_name(s.index)
  if name == nil then
    s.name = "EMPTY"
    s.live = false
  else
    s.name = name
    s.live = true
  end
  s.playing = false
  s.volume = config.volume["row" .. s.y]
  return s
end

function Sample:increment_pointer()
  self.pointer = util.wrap(self:get_pointer() + 1, 1, self:get_length())
end

function Sample:trigger()
  _grid:register_flicker_at(self:get_x(), self:get_y())
  local path = filesystem:get_sample_path() .. "/" .. self:get_name()
  local amp = 1
  local variation = config.volume_variation["row" .. self:get_y()]
  if variation > 0 then 
    local is_louder = math.random(0, 1)
    if is_louder == 0 then
      is_louder = -1
    end
    local value = math.random(0, variation)
    amp = util.clamp(self:get_volume() + (value * is_louder), 0, 100) * .01
  end
  local amp_lag = 0
  local sample_start = 0
  local sample_end = 1
  local loop = 0
  local rate = 1
  local trig = 1
  engine.play(path, amp, amp_lag, sample_start, sample_end, loop, rate, trig)
end

function Sample:irradiate()
  local row = "row" .. self:get_y()
  self:set_speed(config.speed[row])
  self:set_density(math.random(config.min_density[row], config.max_density[row]))
  self:set_length(math.random(config.min_length[row], config.max_length[row]))
  self:set_offset(math.random(config.min_offset[row], config.max_offset[row]))
  self:set_er()
end

function Sample:set_er()
  self.er = er.gen(self:get_density(), self:get_length(), self:get_offset())
end

function Sample:get_pointer()
  return self.pointer
end

function Sample:set_speed(i)
  self.speed = i
end

function Sample:get_speed()
  return self.speed
end

function Sample:get_er()
  return self.er
end

function Sample:set_offset(i)
  self.offset = i
end

function Sample:get_offset()
  return self.offset
end

function Sample:set_length(i)
  self.length = i
  self:set_er()
end

function Sample:get_length()
  return self.length
end

function Sample:set_density(i)
  self.density = i
  self:set_er()
end

function Sample:get_density()
  return self.density
end

function Sample:toggle()
  self.playing = not self.playing
  return self.playing
end

function Sample:play()
  self.playing = true
end

function Sample:stop()
  self.playing = false
end

function Sample:get_name()
  return self.name
end

function Sample:get_x()
  return self.x
end

function Sample:get_y()
  return self.y
end

function Sample:get_index()
  return self.index
end

function Sample:is_playing()
  return self.playing
end

function Sample:is_live()
  return self.live
end

function Sample:set_volume(i)
  self.volume = util.clamp(i, 0, 100)
end

function Sample:get_volume()
  return self.volume
end