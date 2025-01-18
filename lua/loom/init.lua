local M = {}

local border = require("githelper.border")

function M.setup(opts)
  opts = opts or {}

  local keymap = opts.keymap or "<leader>t"

  vim.keymap.set("n", keymap, function()
    local Loom = require("loom.loomClass")

    Loom:new( opts.gitKeymap)
    Window:open()

    if vim.fn.has("nvim-0.7.0") ~= 1 then
      vim.api.nvim_err_writeln("Example.nvim requires at least nvim-0.7.0.")
      return;
    end
  end
  )
end

return M
