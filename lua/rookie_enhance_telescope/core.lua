local M = {}

-- Search state
M.search_opts = {
    case_sensitive = true,
    whole_word = true,
    is_regex = false,
}

function M.get_vimgrep_args()
    local args = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
    }

    -- Case sensitive
    if M.search_opts.case_sensitive then
        table.insert(args, "--case-sensitive")
    else
        table.insert(args, "--smart-case")
    end

    -- Whole word
    if M.search_opts.whole_word then
        table.insert(args, "--word-regexp")
    end

    -- Regex (Enabled by default in rg, but can be disabled via --fixed-strings)
    if not M.search_opts.is_regex then
        table.insert(args, "--fixed-strings")
    end

    return args
end

function M.live_grep_with_flags(default_text, is_refresh)
    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    if not is_refresh and (default_text == nil or default_text == "") then
        default_text = vim.fn.expand("<cword>")
    end

    local title = string.format(
        "Live Grep (ca[S]e:%s, [W]ord:%s, [R]egex:%s)",
        M.search_opts.case_sensitive and "On" or "Off",
        M.search_opts.whole_word and "On" or "Off",
        M.search_opts.is_regex and "On" or "Off"
    )

    local vimgrep_args = M.get_vimgrep_args()
    local sorters = require("telescope.sorters")

    builtin.live_grep({
        cwd = vim.fn.getcwd(),
        prompt_title = title,
        default_text = default_text,
        vimgrep_arguments = vimgrep_args,
        sorter = sorters.get_substr_matcher(),
        attach_mappings = function(prompt_bufnr, map)
            local function refresh_with_toggle(toggle_key)
                local current_input = action_state.get_current_line()
                if toggle_key == "case" then
                    M.search_opts.case_sensitive = not M.search_opts.case_sensitive
                elseif toggle_key == "word" then
                    M.search_opts.whole_word = not M.search_opts.whole_word
                elseif toggle_key == "regex" then
                    M.search_opts.is_regex = not M.search_opts.is_regex
                end

                actions.close(prompt_bufnr)
                M.live_grep_with_flags(current_input, true)
            end

            map("i", "<C-s>", function() refresh_with_toggle("case") end)
            map("i", "<C-w>", function() refresh_with_toggle("word") end)
            map("i", "<C-r>", function() refresh_with_toggle("regex") end)

            return true
        end,
    })
end

return M