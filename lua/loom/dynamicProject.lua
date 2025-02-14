
local M = {}
-- local jsonWow = require('dkjson')
local JsonFile = require("loom.json_file")
-- local popup = require('plenary.popup')

local json_file = vim.fn.expand('~/.config/nvim/projects.json')
local data = {}
local pane_win = nil

-- Load JSON file
local function load_json()
  local f = io.open(json_file, 'r')
  if f then
    local content = f:read('*a')
    f:close()
    -- data = jsonWow.decode(content) or {}
  end
end

-- Save JSON file
local function save_json()
  local jsonLocalProject = JsonFile:new(vim.fn.expand("~/.config/nvimPlug/loom.nvim/lua/loom/data.json"));
  jsonLocalProject:write(data)
end

-- Delete entry
local function delete_entry(index)
  table.remove(data, index)
  save_json()
  M.show_pane()
end

-- Open floating window to edit JSON
local function edit_entry(index)
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
      save_json()

      vim.api.nvim_win_close(win, true)
      M.show_pane()
    end
  })
end

-- Display Harpoon-like pane
function M.show_pane()
  --
  -- todo :: allez chercher le data
  local jsonLocalProject = JsonFile:new(vim.fn.expand("~/.config/nvimPlug/loom.nvim/lua/loom/data.json"));
  local dynamicProject = jsonLocalProject:read();

  if pane_win and vim.api.nvim_win_is_valid(pane_win) then
    vim.api.nvim_win_close(pane_win, true)
  end

  data = dynamicProject;
  local lines = {}
  for i, entry in ipairs(data) do
    table.insert(lines, i .. ': ' .. entry.name .. ' -> ' .. entry.path)
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
    border = 'rounded'
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'd', '', {
    callback = function()
      local line = vim.api.nvim_win_get_cursor(pane_win)[1]
      delete_entry(line)
    end
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'e', '', {
    callback = function()
      local line = vim.api.nvim_win_get_cursor(pane_win)[1]
      edit_entry(line)
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


  -- tODO :: keyap to send in clipboard a json config for the current config...
  --
  -- to add to the plugin config. So it will be permanent
end

return M
