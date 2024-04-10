local Job = require("plenary.job")
local Path = require("plenary.path")
local notify = require("bjufre.worktree.notify")

local M = {}
local RUN_MIGRATIONS = false

M.exec = function(worktree_path, env)
  print(string.format("DBLOCAL EXISTS: %s", Path:new(worktree_path):joinpath("config/dblocal.yml"):exists()))
  if not Path:new(worktree_path):joinpath("config/dblocal.yml"):exists() then
    -- Make sure that we have the local DB config
    Job:new({
      env = env,
      command = "cp",
      cwd = "~/code/hubstaff-server",
      on_exit = notify("DB Config", "Copied local config"),
      args = { "./master/config/dblocal.yml", worktree_path .. "/config/dblocal.yml" },
    }):sync()
  end

  if not Path:new(worktree_path):joinpath(".env"):exists() then
    -- Make sure that we have the local .env file
    Job:new({
      env = env,
      command = "cp",
      cwd = "~/code/hubstaff-server",
      on_exit = notify("ENV", "Copied .env file"),
      args = { "./master/.env", worktree_path .. "/.env" },
    }):sync()
  end

  if not Path:new(worktree_path):joinpath(".npmrc"):exists() then
    -- Make sure that we have the local .env file
    Job:new({
      env = env,
      command = "cp",
      cwd = "~/code/hubstaff-server",
      on_exit = notify("NPMRC", "Copied .npmrc file"),
      args = { "./master/.npmrc", worktree_path .. "/.npmrc" },
    }):sync()
  end

  local jobs = {
    -- Reset the `puma-dev` symlinks
    Job:new({
      env = env,
      command = "puma-link",
      args = { "app.hubstaff", worktree_path },
      on_exit = notify("PUMA-LINK", worktree_path .. " 🔗!"),
    }),
    -- Gem bundle dependencies
    Job:new({
      env = env,
      command = "bundle",
      on_exit = notify("BUNDLE", "💎 installed!"),
    }),
  }

  if RUN_MIGRATIONS then
    table.insert(
      jobs,
      -- Migrate the database
      Job:new({
        env = env,
        command = "bundle",
        args = { "exec", "rails", "db:migrate" },
        on_exit = notify("DB", "Database migrated!"),
      })
    )
  end

  table.insert(
    jobs,
    -- Install the NPM deps
    Job:new({
      env = env,
      command = "pnpm",
      args = { "install" },
      on_exit = notify("NPM", "📦 installed!"),
    })
  )

  Job.chain(unpack(jobs))
end

return M
