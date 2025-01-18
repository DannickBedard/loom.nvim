local api = vim.api
local buf, win

local border = require("githelper.border")


local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local sorters = require("telescope.config").values.generic_sorter



-- Meta class
Loom = {  keymap, projects }


function Loom:new( gitKeymap)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  self.keymap = keymap or {}
  self.projects = projects or {}
  return o
end

function Loom:open()
  -- TODO :: open telescope
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
    attach_mappings = function(_, map)
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

local function open_split()
  projectPicker(function (path, name)
    vim.cmd("tabnew")              -- Open a vertical split
    vim.cmd("lcd " .. path)         -- Set the local working directory for the new split
    vim.cmd("edit .")
    vim.cmd("LualineRenameTab " .. name) -- Rename tab for the current project
  end)

end

function Loom:set_mappings()
  local defaultGitKeymap = {
    open_split = "C-S",
    open_vsplit = "C-s",
    open_current_window = "C-w",
    open_new_tab = "C-t",
  }

  local mappings = {
    [self.keymap.open_split or defaultGitKeymap.open_split] = function ()
      open_split()
    end,
    [self.keymap.open_vsplit or defaultGitKeymap.open_vsplit] = function ()
      Window:close_window()
    end ,
    [self.keymap.open_current_window or defaultGitKeymap.open_current_window] = function ()
      stage_file()
    end,
    [self.keymap.open_new_tab or defaultGitKeymap.open_new_tab] = function ()
      unstage_file()
    end
  }

  for k,v in pairs(mappings) do
    vim.keymap.set("n", k, function()
      -- api.nvim_buf_set_keymap(buf, 'n', k, function ()
      v()
    end, {
        buffer = buf, nowait = true, noremap = true, silent = true
      })
  end

  -- Disable key while using the plugin
  local other_chars = {
    't','a', 'b', 'e', 'f', 'i', 'n', 'o', 'r', 'v', 'w', 'x', 'y', 'z'
  }

  for k,v in ipairs(other_chars) do
    api.nvim_buf_set_keymap(buf, 'n', v, '', { nowait = true, noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, 'n', v:upper(), '', { nowait = true, noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, 'n',  '<c-'..v..'>', '', { nowait = true, noremap = true, silent = true })
  end

end

local function window(content, opts)
  Window:open_window()
  Window:update_view()
  api.nvim_win_set_cursor(win, {4, 0})
end

return Window
