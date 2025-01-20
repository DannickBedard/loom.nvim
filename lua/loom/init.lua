local M = {}

function M.setup(opts)
  opts = opts or {}

  local keymapOpenPicker = (opts.keymap and opts.keymap.openPicker) or "<leader>op"

  local Loom = require("loom.loomClass")
  Loom:new(opts.keymap, opts.projects)
  Loom:set_mappings() -- Will take the mapping pass into the constructor

  vim.keymap.set("n", keymapOpenPicker, function()
    Loom:open()

    if vim.fn.has("nvim-0.7.0") ~= 1 then
      vim.api.nvim_err_writeln("Example.nvim requires at least nvim-0.7.0.")
      return;
    end
  end
  )
end

return M
