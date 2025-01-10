local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

local function split_files(first_file, second_file)
  vim.cmd.tabnew(first_file)
  vim.cmd("vertical diffsplit " .. second_file)
  vim.cmd.normal({ args = { "gg" }, bang = true })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

local function diff_files(opts)
  opts = opts or {}
  local outer_opts = {
    prompt_title = "Pick first file",
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local inner_opts = {
          prompt_title = "Pick second file",
          attach_mappings = function(_, inner_map)
            inner_map("i", "<CR>", function(second_prompt_bufnr)
              actions.close(second_prompt_bufnr)
              local second_selection = action_state.get_selected_entry()
              split_files(selection.path, second_selection.path)
            end)
            return true
          end,
        }
        inner_opts = vim.tbl_extend("force", opts, inner_opts)
        builtin.find_files(inner_opts)
      end)
      return true
    end,
  }
  opts = vim.tbl_extend("force", opts, outer_opts)
  builtin.find_files(opts)
end

local function diff_current(opts)
  opts = opts or {}
  local local_opts = {
    prompt_title = "Pick file to compare",
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local current_filepath = vim.fn.expand(vim.api.nvim_buf_get_name(opts.bufnr))
        local selection = action_state.get_selected_entry()
        split_files(current_filepath, selection.path)
      end)
      return true
    end,
  }
  opts = vim.tbl_extend("force", opts, local_opts)
  builtin.find_files(opts)
end

vim.api.nvim_create_user_command("DiffCurrent", function()
  require("telescope").extensions.diff.diff_current({ hidden = true })
end, {})

vim.api.nvim_create_user_command("DiffFiles", function()
  require("telescope").extensions.diff.diff_files({ hidden = true })
end, {})

return require("telescope").register_extension({
  exports = {
    diff_files = diff_files,
    diff_current = diff_current,
  },
})
