-- This is a workaround for the fact that we need to pass the `upstream` to the
-- worktree creation when using Telescope; at the same time this adaptation
-- adds a little bit of custom logic so that the local branch created from
-- the selected branch, doesn't have the `<upstream>/` prefix.
-- From:
local create_telescope_worktree = function()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  local opts = {}
  opts.attach_mappings = function()
    actions.select_default:replace(
      function(prompt_bufnr, _)
        local selected_entry = action_state.get_selected_entry()
        local current_line = action_state.get_current_line()

        actions.close(prompt_bufnr)

        local branch = selected_entry ~= nil and
            selected_entry.value or current_line

        if branch == nil then
          return
        end

        local upstream = 'origin'
        local name = vim.fn.input("Path to subtree > ")

        if name == "" then
          name = branch
        end

        branch = branch:gsub(upstream .. '/', '')
        require('git-worktree').create_worktree(name, branch, upstream)
      end)

    -- do we need to replace other default maps?

    return true
  end
  require("telescope.builtin").git_branches(opts)
  -- telescope.extensions.git_worktree.create_git_worktree()
end

return {
  'ThePrimeagen/git-worktree.nvim',
  enabled = true,
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local worktree = require('git-worktree')

    worktree.setup({
      change_directory_command = "cd",  -- default
      update_on_change = true,          -- default
      update_on_change_command = "e .", -- default
      clearjumps_on_change = true,      -- default
      autopush = false,                 -- default
    })

    local Path = require('plenary.path')

    -- op = Operations.Switch, Operations.Create, Operations.Delete
    -- metadata = table of useful values (structure dependent on `op`)
    --      Switch
    --          path = path you switched to
    --          prev_path = previous worktree path
    --      Create
    --          path = path where worktree created
    --          branch = branch name
    --          upstream = upstream remote name
    --      Delete
    --          path = path where worktree deleted
    worktree.on_tree_change(function(op, metadata)
      local env = { PATH = vim.env.PATH }

      -- If we're dealing with create, the path is relative to the worktree and not absolute
      -- so we need to convert it to an absolute path.
      local new_path = metadata.path
      if not Path:new(new_path):is_absolute() then
        new_path = Path:new():absolute()
        if new_path:sub(- #'/') == '/' then
          new_path = string.sub(new_path, 1, string.len(new_path) - 1)
        end
      end

      -- TODO: If we're inside TMUX send rename window command
      -- For the current window to use the worktree basename.

      if op == worktree.Operations.Switch or op == worktree.Operations.Create then
        -- If we're inside the `hubstaff-server` make sure we
        -- execute the correct workflow.
        if new_path:find('hubstaff-server', 1, true) then
          require('bjufre.worktree.hubstaff.server').exec(new_path, env)
        end

        if new_path:find('hubstaff-zone', 1, true) then
          require('bjufre.worktree.hubstaff.zone').exec(new_path, env)
        end
      end
    end)

    local telescope = require('telescope')

    telescope.register_extension('git_worktree')
  end,
  keys = {
    { '<leader>gwl', function() require('telescope').extensions.git_worktree.git_worktrees() end },
    { '<leader>gwa', create_telescope_worktree },
  }
}
