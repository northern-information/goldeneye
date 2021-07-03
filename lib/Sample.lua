Sample = {}

function Sample:new(x, y)
  local s = setmetatable({}, { __index = Sample })
  s.x = x
  s.y = y
  s.id = "sample-" .. samples:id()  -- unique identifier for this sample
  s.index = samples:index(x, y) -- location on the grid
  local name = filesystem:get_sample_name(s.index)
  if name == nil then
    s.name = "EMPTY"
    s.live = false
  else
    s.name = name
    s.live = true
  end
  s.playing = false
  s.volume = 100
  return s
end

function Sample:toggle()
  self.playing = not self.playing
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