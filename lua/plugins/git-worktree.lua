return {
  "ThePrimeagen/git-worktree.nvim",
  enabled = true,
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local worktree = require("git-worktree")

    worktree.setup({
      change_directory_command = "cd", -- default
      update_on_change = true, -- default
      update_on_change_command = "e .", -- default
      clearjumps_on_change = true, -- default
      autopush = false, -- default
    })

    local Path = require("plenary.path")

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
        if new_path:sub(-#"/") == "/" then
          new_path = string.sub(new_path, 1, string.len(new_path) - 1)
        end
      end

      -- TODO: If we're inside TMUX send rename window command
      -- For the current window to use the worktree basename.

      if op == worktree.Operations.Switch or op == worktree.Operations.Create then
        -- If we're inside the `hubstaff-server` make sure we
        -- execute the correct workflow.
        if new_path:find("hubstaff-server", 1, true) then
          require("bjufre.worktree.hubstaff.server").exec(new_path, env)
        end

        if new_path:find("hubstaff-zone", 1, true) then
          require("bjufre.worktree.hubstaff.zone").exec(new_path, env)
        end
      end
    end)

    local telescope = require("telescope")

    telescope.register_extension("git_worktree")
  end,
}
