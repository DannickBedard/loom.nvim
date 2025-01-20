local api = vim.api
local buf, win

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local sorters = require("telescope.config").values.generic_sorter

-- Meta class
Loom = {  keymap, projects }

function Loom:new(keymap, projects)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  self.keymap = keymap or {}
  self.projects = projects or {}
  return o
end

local function path_to_vsplit(path)
  vim.cmd("vsplit")
  vim.cmd("wincmd l")            -- Move to the newly created split
  vim.cmd("lcd " .. path)
  vim.cmd("edit .") -- Open the file browser in the project directory
end

local function path_to_split(path)
  vim.cmd("split")
  vim.cmd("wincmd j")            -- Move to the newly created split
  vim.cmd("lcd " .. path)
  vim.cmd("edit .") -- Open the file browser in the project directory
end

local function path_to_new_tab(path, name)
  vim.cmd("tabnew")              -- Open a vertical split
  vim.cmd("lcd " .. path)         -- Set the local working directory for the new split
  vim.cmd("edit .")
  if name then
    vim.cmd("LualineRenameTab " .. name) -- Rename tab for the current project
  end
end

local function path_to_current_window(path, name)
  vim.cmd("lcd " .. path)
  vim.cmd("edit .") -- Open the file browser in the project directory
  if name then
    vim.cmd("LualineRenameTab " .. name) -- Rename tab for the current project
  end
end


local function projectPicker(actionWithPath)

  -- Create the picker
  pickers.new({}, {
    prompt_title = "Select a Project",
    finder = finders.new_table({
      results = Loom.projects,
      entry_maker = function(item)
        return {
          value = item,
          display = item.name,
          ordinal = item.name,
        }
      end,
    }),
    sorter = sorters({}),
    attach_mappings = function(prompt_bufnr, map)

       map("i", "<C-s>", function()
        local selection = action_state.get_selected_entry(prompt_bufnr)
        if selection then
          local path = vim.fn.expand(selection.value.path)
          actions.close(prompt_bufnr) -- Close the picker
          path_to_vsplit(path)
        end
      end)

       map("i", "<C-S>", function()
        local selection = action_state.get_selected_entry(prompt_bufnr)
        if selection then
          local path = vim.fn.expand(selection.value.path)
          actions.close(prompt_bufnr) -- Close the picker
          path_to_split(path)
        end
      end)

      map("i", "<C-t>", function()
        local selection = action_state.get_selected_entry(prompt_bufnr)
        if selection then
          local path = vim.fn.expand(selection.value.path)
          local name = vim.fn.expand(selection.value.name)
          actions.close(prompt_bufnr) -- Close the picker
          path_to_new_tab(path, name)
        end
      end)

      map("i", "<C-w>", function()
        local selection = action_state.get_selected_entry(prompt_bufnr)
        if selection then
          local path = vim.fn.expand(selection.value.path)
          local name = vim.fn.expand(selection.value.name)
          actions.close(prompt_bufnr) -- Close the picker
          path_to_current_window(path, name)
        end
      end)

      -- Define what happens on selection
      actions.select_default:replace(function(prompt_bufnr)
        local selection = action_state.get_selected_entry(prompt_bufnr)
        local path = vim.fn.expand(selection.value.path)
        local name = vim.fn.expand(selection.value.name)
        actions.close(prompt_bufnr)

        actionWithPath(path, name)
      end)
      return true
    end,
  }):find()
end

function Loom:open()
  projectPicker()
  -- TODO :: open telescope
end

local function open_project_in_vsplit()
  projectPicker(function (path, name)
    path_to_vsplit(path)
  end)
end

local function open_project_in_split()
  projectPicker(function (path, name)
    path_to_split(path)
  end)
end

local function open_project_in_current_window()
  projectPicker(function (path, name)
    path_to_current_window(path, name)
  end)
end

local function open_project_in_new_tab()
  projectPicker(function (path, name)
    path_to_new_tab(path, name)
  end)
end



function Loom:set_mappings()
  local defaultGitKeymap = {
    open_split = "<leader>opS",
    open_vsplit = "<leader>ops",
    open_current_window = "<leader>opw",
    open_new_tab = "<ealder>opt",
  }

  local mappings = {
    [self.keymap.open_split or defaultGitKeymap.open_split] = function ()
      open_project_in_split()
    end,
    [self.keymap.open_vsplit or defaultGitKeymap.open_vsplit] = function ()
      open_project_in_vsplit()
    end ,
    [self.keymap.open_current_window or defaultGitKeymap.open_current_window] = function ()
      open_project_in_current_window()
    end,
    [self.keymap.open_new_tab or defaultGitKeymap.open_new_tab] = function ()
      open_project_in_new_tab()
    end
  }

  for key,func in pairs(mappings) do
    vim.keymap.set("n", key, function()
      func()
    end, {
        buffer = buf, nowait = true, noremap = true, silent = true
      })
  end

  -- Disable key while using the plugin
  local other_chars = {
    't','a', 'b', 'e', 'f', 'i', 'n', 'o', 'r', 'v', 'w', 'x', 'y', 'z'
  }

  for k,v in ipairs(other_chars) do
    -- api.nvim_buf_set_keymap(buf, 'n', v, '', { nowait = true, noremap = true, silent = true })
    -- api.nvim_buf_set_keymap(buf, 'n', v:upper(), '', { nowait = true, noremap = true, silent = true })
    -- api.nvim_buf_set_keymap(buf, 'n',  '<c-'..v..'>', '', { nowait = true, noremap = true, silent = true })
  end

end

local function window(content, opts)
  -- Window:open_window()
  -- api.nvim_win_set_cursor(win, {4, 0})
end

return Loom
