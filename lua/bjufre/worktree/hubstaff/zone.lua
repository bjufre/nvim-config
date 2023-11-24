local Job = require('plenary.job')
local Path = require('plenary.path')
local notify = require('bjufre.worktree.notify')

local M = {}

M.exec = function(worktree_path, env)
  if Path:new("~/code/hubstaff-zone/main"):joinpath('.env'):exists() then
    if not Path:new(worktree_path):joinpath('.env'):exists() then
      -- Make sure that we have the local .env file
      Job:new({
        env = env,
        command = 'cp',
        cwd = '~/code/hubstaff-zone',
        on_exit = notify('ENV', 'Copied .env file'),
        args = { './main/.env', worktree_path .. '/.env' },
      }):sync()
    end
  end

  if not Path:new(worktree_path):joinpath('.npmrc'):exists() then
    -- Make sure that we have the local .env file
    Job:new({
      env = env,
      command = 'cp',
      cwd = '~/code/hubstaff-zone',
      on_exit = notify('NPMRC', 'Copied .npmrc file'),
      args = { './main/.npmrc', worktree_path .. '/.npmrc' },
    }):sync()
  end

  local jobs = {
    -- Reset the `puma-dev` symlinks
    Job:new({
      env = env,
      command = 'puma-link',
      args = { 'zone.hubstaff', worktree_path .. '/docs' },
      on_exit = notify('PUMA-LINK', worktree_path .. ' 🔗!'),
    }),
    -- Gem bundle dependencies
    Job:new({
      env = env,
      command = 'bundle',
      on_exit = notify('BUNDLE', '💎 installed!'),
    }),
  }

  table.insert(jobs,
    -- Install the NPM deps
    Job:new({
      env = env,
      command = 'pnpm',
      args = { 'install' },
      on_exit = notify('PNPM', '📦 installed!'),
    })
  )

  Job.chain(unpack(jobs))
end

return M
