# Telescope-diff.nvim
Quick file diffs with the power of Telescope.nvim.

## Preview


## Features

- Diff current file with a file picked from Telescope
- Diff 2 files picked from Telescope

## Installation
With [ Lazy.nvim ](https://github.com/folke/lazy.nvim):
```lua
  {
    "jemag/telescope-diff.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    }
  },
```

Then, somewhere after `require("telescope").setup`, load the extension using:
```lua
require("telescope").load_extension("diff")
```

You may also add keybinds, for example:
```lua
vim.keymap.set("n", "<localleader>sC", function()
  require("telescope").extensions.diff.diff_files({ hidden = true })
end, { desc = "Compare 2 files" })
vim.keymap.set("n", "<localleader>sc", function()
  require("telescope").extensions.diff.diff_current({ hidden = true })
end, { desc = "Compare file with current" })
```
