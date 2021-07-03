filesystem = {}

function filesystem.init()
  filesystem.samples = {}
  filesystem.paths = {}
  filesystem.paths.factory_install = "/home/we/dust/code/goldeneye/factory/"
  filesystem.paths.factory_destination = "/home/we/dust/audio/goldeneye/factory/"
  filesystem.paths.sample_path = config.sample_path
  for k,path in pairs(filesystem.paths) do
    if util.file_exists(path) == false then
      util.make_dir(path)
    end
  end
  filesystem:install_factory_samples()
  filesystem:scan()
end

function filesystem:get_sample_name(index)
  return self.samples[index]
end

function filesystem:install_factory_samples()
  for k, sample in pairs(self:scandir(self.paths.factory_install)) do
    util.os_capture("cp" .. " " .. self.paths.factory_install .. sample .. " " .. self.paths.factory_destination)
  end
end

function filesystem:scandir(directory)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('ls -a "' .. directory .. '"')
  for filename in pfile:lines() do
    if filename ~= "." and filename ~= ".." then
      i = i + 1
      t[i] = filename
    end
  end
  pfile:close()
  return t
end

function filesystem:scan()
  local delete = {"LICENSE", "README.md"}
  local scan = util.scandir(self.paths.sample_path)
  for k, file in pairs(scan) do
    for kk, d in pairs(delete) do
      local find = fn.table_find(scan, d)
      if find then table.remove(scan, find) end
    end
    local name = string.gsub(file, "/", "")
    table.insert(self.samples, name)
  end
end
return filesystem