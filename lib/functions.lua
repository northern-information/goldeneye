fn = {}

function fn.table_find(t, element)
  for i, v in pairs(t) do
    if v == element then
      return i
    end
  end
  return false
end

function rerun()
  norns.script.load(norns.state.script)
end

function r()
  rerun()
end

function fn.break_splash(bool)
  if bool == nil then return splash_break end
  splash_break = bool
  return splash_break
end

function fn.dirty_grid(bool)
  if bool == nil then return grid_dirty end
  grid_dirty = bool
  return grid_dirty
end

function fn.dirty_screen(bool)
  if bool == nil then return screen_dirty end
  screen_dirty = bool
  return screen_dirty
end

return fn