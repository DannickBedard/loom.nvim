# loom.nvim


## Setup

Complet setup

```lua
  return {
   "DannickBedard/loom.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" }
    config = function ()

      local projects = {
        { name = "Notes", path = "~/Documents/Notes" },
        { name = "Viridem", path = "c:/viridem" },
        { name = "Nvim", path = "~/AppData/Local/nvim" },
        { name = "Nvim-local", path = "~/AppData/Local/nvim-local" },
        { name = "Local project", path = "c:/projects" },
        { name = "config user", path = "~/" },
      }

      local keymaps = {
        -- Open the project picker without prepend action.
        -- On selection there will be a action list selection
        open_picker = "<leader>fp",

        -- Action for the picker item
        picker_open_split = "<C-S>",
        picker_open_vsplit = "<C-s>",
        picker_open_tab = "<C-t>",
        picker_open_current_win = "<C-w>",

        -- Open the picker with a action prepend
        -- So on picker selection it will open the project in the actons chosen for the binding
        open_in_split = "<leader>opS",
        open_in_vsplit = "<leader>ops",
        open_in_tab = "<leader>opt",
        open_in_current_win = "<leader>opw",
      }

      require("loom").setup({
        keymaps = keymaps,
        projects = projects,
      });
    end
  }
```

## Keymapping
TODO... See the complet exemple bellow for now



## TODO 
- [x] Make telescope pick a project and be able to navigate
- [x] Make telescope pick a action after a selection
- [x] Add keymap to do action before the telescope picker
- [ ] Make default keybind more intuitive
    Like op alone is long to promt because opt, ops, ops, opw...  case <leader>fp -> find project
