# loom.nvim

**loom.nvim** is a Neovim plugin that enhances your workflow by allowing you to quickly switch between predefined projects using the Telescope picker. You can customize project paths, keybindings, and easily open projects in splits, tabs, or the current window.

---

## Installation

Ensure you have [Telescope](https://github.com/nvim-telescope/telescope.nvim) installed, as it is a dependency for this plugin.

Using **lazy.nvim**:

```lua
return {
  "DannickBedard/loom.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local projects = {
      { name = "project1", path = "~/Documents/project1" },
      { name = "project2", path = "~/Documents/project1" },
    }

    local keymaps = {
      open_picker = "<leader>fp",          -- Open the project picker
      picker_open_split = "<C-S>",        -- Open project in a split (inside the picker)
      picker_open_vsplit = "<C-s>",       -- Open project in a vertical split (inside the picker)
      picker_open_tab = "<C-t>",          -- Open project in a new tab (inside the picker)
      picker_open_current_win = "<C-w>", -- Open project in the current window (inside the picker)

      open_in_split = "<leader>opS",      -- Directly open picker for horizontal split
      open_in_vsplit = "<leader>ops",     -- Directly open picker for vertical split
      open_in_tab = "<leader>opt",        -- Directly open picker for a tab
      open_in_current_win = "<leader>opw" -- Directly open picker for the current window
    }

    require("loom").setup({
      keymaps = keymaps,
      projects = projects,
    })
  end,
}
```

---

## Features

- **Project Picker**: Use Telescope to select and open predefined projects.
- **Customizable Keybindings**: Bind specific actions for opening projects in splits, tabs, or the current window.
- **Action Prepend**: Open the picker with predefined actions for quick navigation.

---


---

## Keybindings

| Keybinding    | Action                                          |
| ------------- | ----------------------------------------------- |
| `<leader>fp`  | Open the project picker                         |
| `<C-S>`       | Open project in a horizontal split (inside picker) |
| `<C-s>`       | Open project in a vertical split (inside picker)   |
| `<C-t>`       | Open project in a new tab (inside picker)          |
| `<C-w>`       | Open project in the current window (inside picker) |
| `<leader>opS` | Directly open picker for horizontal split          |
| `<leader>ops` | Directly open picker for vertical split            |
| `<leader>opt` | Directly open picker for a tab                     |
| `<leader>opw` | Directly open picker for the current window        |

---

## Future Improvements

- Add support for custom keymaps for specific projects. For example, within the project object, you could specify keymaps to open the project in a specific layout (e.g., split, new tab, etc.) directly without going through the picker.

---

Enjoy seamless project navigation with **loom.nvim**!

