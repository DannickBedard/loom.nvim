local api = vim.api
local buf, win

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local JsonFile = require("loom.json_file")
local helper = require("loom.helper.helper")

local sorters = require("telescope.config").values.generic_sorter

-- Meta class
Loom = {
  keymap = {},
  projects = {},
  options = {
    pickerIgnoreDir = false
  },
}

local lualine_available, _ = pcall(require, "lualine")

function Loom:new(keymap, projects, options)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  self.keymap = keymap or {}
  self.projects = projects or {}
  self.options = options or {}
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
  if name and lualine_available then
    vim.cmd("LualineRenameTab " .. name) -- Rename tab for the current project
  end
end

local function path_to_current_window(path, name)
  vim.cmd("lcd " .. path)
  vim.cmd("edit .") -- Open the file browser in the project directory
  if name and lualine_available then

    vim.cmd("LualineRenameTab " .. name) -- Rename tab for the current project
  end
end

local open_actions_enum = {
  open_split = "open_split",
  open_vsplit = "open_vsplit",
  open_new_tab = "open_new_tab",
  open_current_win = "open_current_win",
}

local open_actions = {
  { name = open_actions_enum.open_split },
  { name = open_actions_enum.open_vsplit },
  { name = open_actions_enum.open_new_tab },
  { name = open_actions_enum.open_current_win },
}

local PathHelper = require("loom.PathHelper")
function Loom:getProjects()

  local json = JsonFile:new(PathHelper.getPluginPath());
  local dynamicProject = json:read();

  return helper.merge_table(Loom.projects, dynamicProject)

end

function Loom:projectPicker(actionWithPath)

  -- Create the picker
  pickers.new({}, {
    prompt_title = "Select a Project",
    finder = finders.new_table({
      results = Loom:getProjects(),
      entry_maker = function(item)
        local ordinal = item.name .. " -> (" .. item.path .. ")"

        if  Loom.options.pickerIgnoreDir then
          ordinal = item.name
        end

        return {
          value = item,
          display = item.name .. " -> (" .. item.path .. ")",
          ordinal = ordinal
        }
      end,
    }),
    sorter = sorters({}),
    attach_mappings = function(prompt_bufnr, map)
      local default_picker_binding = {
        open_split = "<C-s>",
        open_vsplit = "<C-v>",
        open_current_window = "<C-w>",
        open_new_tab = "<C-t>",
      }

      local mappings = {
        [self.keymap.open_split or default_picker_binding.open_split] = function ()
          local selection = action_state.get_selected_entry(prompt_bufnr)
          if selection then
            local path = vim.fn.expand(selection.value.path)
            actions.close(prompt_bufnr) -- Close the picker
            path_to_split(path)
          end
        end,
        [self.keymap.open_vsplit or default_picker_binding.open_vsplit] = function ()
          local selection = action_state.get_selected_entry(prompt_bufnr)
          if selection then
            local path = vim.fn.expand(selection.value.path)
            actions.close(prompt_bufnr) -- Close the picker
            path_to_vsplit(path)
          end
        end ,
        [self.keymap.open_current_window or default_picker_binding.open_current_window] = function ()
          local selection = action_state.get_selected_entry(prompt_bufnr)
          if selection then
            local path = vim.fn.expand(selection.value.path)
            local name = vim.fn.expand(selection.value.name)
            actions.close(prompt_bufnr) -- Close the picker
            path_to_current_window(path, name)
          end
        end,
        [self.keymap.open_new_tab or default_picker_binding.open_new_tab] = function ()
          local selection = action_state.get_selected_entry(prompt_bufnr)
          if selection then
            local path = vim.fn.expand(selection.value.path)
            local name = vim.fn.expand(selection.value.name)
            actions.close(prompt_bufnr) -- Close the picker
            path_to_new_tab(path, name)
          end
        end
      }

      for key,func in pairs(mappings) do
        map("i", key, func)
      end

      -- Define what happens on selection
      --  This is a prompt that ask what to do with the selected project.
      --  Notes : You could have used the shortcut to do the action on item instead of selecting
      actions.select_default:replace(function(prompt_bufnr)
        local selection = action_state.get_selected_entry(prompt_bufnr)
        local path = vim.fn.expand(selection.value.path)
        local name = vim.fn.expand(selection.value.name)

        actions.close(prompt_bufnr)

        if actionWithPath then
          actionWithPath(path, name)
        else
          -- Fallback on a action selector
          pickers.new({}, {
            prompt_title = "Select action",
            finder = finders.new_table({
              results = open_actions, -- TODO changer
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
              -- Define what happens on selection
              actions.select_default:replace(function(prompt_bufnr)
                local selection_action = action_state.get_selected_entry(prompt_bufnr)

                local action_name = vim.fn.expand(selection_action.value.name)

                actions.close(prompt_bufnr)

                print(action_name)
                if action_name == open_actions_enum.open_split then
                  path_to_split(path)
                end

                if action_name == open_actions_enum.open_vsplit then
                  path_to_vsplit(path)
                end

                if action_name == open_actions_enum.open_current_win then
                  path_to_current_window(path, name)
                end

                if action_name == open_actions_enum.open_new_tab then
                  path_to_new_tab(path, name)
                end

              end)
              return true
            end,
          }):find()
        end

      end)
      return true
    end,
  }):find()
end

function Loom:open()
  Loom:projectPicker()
end

local function open_project_in_vsplit()
  Loom:projectPicker(function (path)
    path_to_vsplit(path)
  end)
end

local function open_project_in_split()
  Loom:projectPicker(function (path)
    path_to_split(path)
  end)
end

local function open_project_in_current_window()
  Loom:projectPicker(function (path, name)
    path_to_current_window(path, name)
  end)
end

local function open_project_in_new_tab()
  Loom:projectPicker(function (path, name)
    path_to_new_tab(path, name)
  end)
end

function Loom:set_mappings()
  local defaultPrependMapping = {
    open_split = "<leader>ops",
    open_vsplit = "<leader>opv",
    open_current_window = "<leader>opw",
    open_new_tab = "<leader>opt",
    add_project = "<leader>opt",
    remove_project = "<leader>opt",
  }

  -- Mapping for pre-actions. 
  local mappings = {
    [self.keymap.open_split or defaultPrependMapping.open_split] = function ()
      open_project_in_split()
    end,
    [self.keymap.open_vsplit or defaultPrependMapping.open_vsplit] = function ()
      open_project_in_vsplit()
    end ,
    [self.keymap.open_current_window or defaultPrependMapping.open_current_window] = function ()
      open_project_in_current_window()
    end,
    [self.keymap.open_new_tab or defaultPrependMapping.open_new_tab] = function ()
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

end

return Loom
