local core = require("rookie_enhance_telescope.core")

local M = {}

function M.setup()
    vim.api.nvim_create_user_command("RkLiveGrep", function()
        core.live_grep_with_flags("", false)
    end, { desc = "Live Grep with togglable VS Code like flags" })

    vim.api.nvim_create_user_command("RkGlobalReplace", function()
        -- Use preferred defaults (Case On, Regex Off, Word Off)
        core.search_opts.case_sensitive = true
        core.search_opts.is_regex = false
        core.search_opts.whole_word = false

        local search_text = vim.fn.expand("<cword>")
        -- Show search picker first to let user choose parameters
        core.live_grep_with_flags(search_text, true)
    end, { desc = "Global Replace with togglable VS Code like flags" })

    vim.api.nvim_create_user_command("RkGlobalReplaceUndo", function()
        core.global_replace_undo()
    end, { desc = "Undo the last Global Replace operation" })
end

return M