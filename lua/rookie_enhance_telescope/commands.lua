local core = require("rookie_enhance_telescope.core")

local M = {}

function M.setup()
    vim.api.nvim_create_user_command("RkLiveGrep", function()
        -- Reset to defaults
        core.search_opts.case_sensitive = true
        core.search_opts.whole_word = true
        core.search_opts.is_regex = false
        core.live_grep_with_flags("", false)
    end, { desc = "Live Grep with togglable VS Code like flags" })
end

return M