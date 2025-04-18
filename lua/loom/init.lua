local M = {}

function M.setup(opts)
  opts = opts or {}

  local keymapOpenPicker = (opts.keymaps and opts.keymaps.open_picker) or "<leader>op"

  local Loom = require("loom.loomClass")

  Loom:new(opts.keymaps, opts.projects, opts.options)
  Loom:set_mappings() -- Will take the mapping pass into the constructor

  vim.keymap.set("n", keymapOpenPicker, function()
    Loom:open()

  end
  )
end

function M.add_project_to_local_storage()
  local loomProject = require("loom.dynamicProject")
  loomProject.add_project_to_local_storage()
end

function M.show_projects_pane()
  local loomProject = require("loom.dynamicProject")
  loomProject.show_projects_pane()
end

return M
