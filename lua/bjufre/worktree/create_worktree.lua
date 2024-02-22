-- This is a workaround for the fact that we need to pass the `upstream` to the
-- worktree creation when using Telescope; at the same time this adaptation
-- adds a little bit of custom logic so that the local branch created from
-- the selected branch, doesn't have the `<upstream>/` prefix.
-- From:
return function()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local opts = {}
  opts.attach_mappings = function()
    actions.select_default:replace(function(prompt_bufnr, _)
      local selected_entry = action_state.get_selected_entry()
      local current_line = action_state.get_current_line()

      actions.close(prompt_bufnr)

      local branch = selected_entry ~= nil and selected_entry.value or current_line

      if branch == nil then
        return
      end

      local upstream = "origin"
      local name = vim.fn.input("Path to subtree > ")

      if name == "" then
        name = branch
      end

      branch = branch:gsub(upstream .. "/", "")
      require("git-worktree").create_worktree(name, branch, upstream)
    end)

    -- do we need to replace other default maps?

    return true
  end
  require("telescope.builtin").git_branches(opts)
  -- telescope.extensions.git_worktree.create_git_worktree()
end
