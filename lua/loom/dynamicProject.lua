local Path = require("plenary.path")

local M = {}
local JsonFile = require("loom.json_file")

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


local PathHelper = require("loom.PathHelper")

local json_file_path = get_plugin_path()
local data = {}
local pane_win = nil

-- Save JSON file
local function save_project_data()
  local jsonLocalProject = JsonFile:new(PathHelper.getPluginPath());
  jsonLocalProject:write(data)
end

-- Delete entry
local function delete_project_from_local_storage(index)
  table.remove(data, index)
  save_project_data()
  M.show_projects_pane()
end

-- Open floating window to edit JSON
local function pane_edit_entry(index)
  local entry = data[index]
  if not entry then return end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { entry.name, entry.path })
  
  local width, height = 40, 5
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = "Edit the config",
    footer = "(Line 1 is the name, Line 2 is the path)"

  })

  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '', {
    callback = function()
      local new_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      data[index] = { name = new_lines[1], path = new_lines[2] }
      save_project_data()

      vim.api.nvim_win_close(win, true)
      M.show_projects_pane()
    end
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    callback = function()
      vim.api.nvim_win_close(win, true)
    end
  })



end

-- Display Harpoon-like pane
function M.show_projects_pane()

  local jsonLocalProject = JsonFile:new(PathHelper.getPluginPath());
  local dynamicProject = jsonLocalProject:read();

  if pane_win and vim.api.nvim_win_is_valid(pane_win) then
    vim.api.nvim_win_close(pane_win, true)
  end

  data = dynamicProject;
  local lines = {}
  for i, entry in ipairs(data) do

    table.insert(lines, string.format("%s: %s -> %s", i, entry.name, entry.path))
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width, height = 50, #lines + 2
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  pane_win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = "Dynamic projects",
    footer = "(e => edit config, q => exit)"
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'd', '', {
    callback = function()
      local line = vim.api.nvim_win_get_cursor(pane_win)[1]
      delete_project_from_local_storage(line)
    end
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'e', '', {
    callback = function()
      local line = vim.api.nvim_win_get_cursor(pane_win)[1]
      pane_edit_entry(line)
    end
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    callback = function()
      if pane_win and vim.api.nvim_win_is_valid(pane_win) then
        vim.api.nvim_win_close(pane_win, true)
        pane_win = nil
      end
    end
  })



  -- TODO :: keyap to send in clipboard a json config for the current config...
  --
  -- to add to the plugin config. So it will be permanent

end

function M.add_project_to_local_storage()
  local currentDir = vim.loop.cwd()
  local projectName = vim.fn.input("Project name: ", "")

  local json = JsonFile:new(PathHelper.getPluginPath());
  local newProject = {
    name = projectName,
    path = currentDir
  }

  json:append(newProject)
end

return M
