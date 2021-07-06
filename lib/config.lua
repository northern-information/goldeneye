config = {}
-- default sample path
config["sample_path"] = "/home/we/dust/audio/goldeneye/factory"
-- set your own sample path like so:
-- config["sample_path"] = "/home/we/dust/audio/common/808"

-- all following configuration values effect entire rows on the grid:

config["speed"] = {
  -- 1 is fastest, 16 is slowest
  ["row1"] = 1,
  ["row2"] = 2,
  ["row3"] = 3,
  ["row4"] = 4,
  ["row5"] = 5,
  ["row6"] = 6,
  ["row7"] = 7,
  ["row8"] = 8
}
config["volume"] = {
  -- 0 to 100
  ["row1"] = 100,
  ["row2"] = 90,
  ["row3"] = 80,
  ["row4"] = 70,
  ["row5"] = 100,
  ["row6"] = 100,
  ["row7"] = 100,
  ["row8"] = 100
}
config["volume_variation"] = {
  -- values in +/- percentage variation each hit
  ["row1"] = 10,
  ["row2"] = 10,
  ["row3"] = 10,
  ["row4"] = 10,
  ["row5"] = 10,
  ["row6"] = 10,
  ["row7"] = 10,
  ["row8"] = 10
}
config["min_density"] = {
  -- 0 to ... less than equal max_density ?
  ["row1"] = 1,
  ["row2"] = 1,
  ["row3"] = 1,
  ["row4"] = 1,
  ["row5"] = 1,
  ["row6"] = 1,
  ["row7"] = 1,
  ["row8"] = 1
}
config["max_density"] = {
  -- 1 to ... ?
  ["row1"] = 16,
  ["row2"] = 16,
  ["row3"] = 16,
  ["row4"] = 16,
  ["row5"] = 16,
  ["row6"] = 16,
  ["row7"] = 16,
  ["row8"] = 16
}
config["min_length"] = {
  -- 1 to ... less than equal max_length ?
  ["row1"] = 8,
  ["row2"] = 8,
  ["row3"] = 8,
  ["row4"] = 8,
  ["row5"] = 8,
  ["row6"] = 8,
  ["row7"] = 8,
  ["row8"] = 8
}
config["max_length"] = {
  -- 1 to .... ?
  ["row1"] = 16,
  ["row2"] = 16,
  ["row3"] = 16,
  ["row4"] = 16,
  ["row5"] = 16,
  ["row6"] = 16,
  ["row7"] = 16,
  ["row8"] = 16
}
config["min_offset"] = {
  -- 0 to 15
  ["row1"] = 0,
  ["row2"] = 0,
  ["row3"] = 0,
  ["row4"] = 0,
  ["row5"] = 0,
  ["row6"] = 0,
  ["row7"] = 0,
  ["row8"] = 0
}
config["max_offset"] = {
  -- 0 to 15
  ["row1"] = 15,
  ["row2"] = 15,
  ["row3"] = 15,
  ["row4"] = 15,
  ["row5"] = 15,
  ["row6"] = 15,
  ["row7"] = 15,
  ["row8"] = 15
}
return config