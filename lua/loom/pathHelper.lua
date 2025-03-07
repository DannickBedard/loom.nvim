
local Path = require("plenary.path")
local PathHelper = {}
PathHelper.__index = PathHelper


local data_path = string.format("%s%sloom", vim.fn.stdpath("data"), Path.sep)
local ensured_data_path = false

local function ensure_data_path()
    if ensured_data_path then
        return
    end

    local path = Path:new(data_path)
    if not path:exists() then
        path:mkdir()
    end
    ensured_data_path = true
end

local function get_plugin_path()
  ensure_data_path()

  return string.format("%s%s%s.json", data_path,Path.sep ,"data")
end

local json_file_path = get_plugin_path()

function PathHelper.getPluginPath()
  return json_file_path
end

return PathHelper
