local M = {}

function M.setup()
    local has_telescope, telescope = pcall(require, "telescope")

    if not has_telescope then
        -- Fallback if telescope not enabled
        require("rookie_enhance_telescope.keymaps").setup()
        return
    end

    local core = require("rookie_enhance_telescope.core")

    -- Global config
    telescope.setup({
        defaults = {
            vimgrep_arguments = core.get_vimgrep_args(),
            mappings = {
                i = {
                    ["<C-v>"] = function()
                        local clipboard = vim.fn.getreg("+")
                        -- Remove newlines as telescope input is single line
                        clipboard = clipboard:gsub("\n", ""):gsub("\r", "")
                        vim.api.nvim_put({ clipboard }, "c", true, true)
                    end,
                },
            },
        },
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown(),
            },
        },
    })

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")

    require("rookie_enhance_telescope.commands").setup()
    require("rookie_enhance_telescope.keymaps").setup()
end

return M