# rookie_enhance_telescope.nvim

## Installation

Use lazy.nvim to install this plugin.

```lua
require("lazy").setup({
    {
        "modulomedito/rookie_enhance_telescope.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("rookie_enhance_telescope").setup()
        end,
    },
})
```
