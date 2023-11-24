return {
  'windwp/nvim-spectre',
  enabled = false,
  -- Use the defaults for now.
  -- Check this for more detailed information about those:
  -- https://github.com/nvim-pack/nvim-spectre#customize
  opts = {
    find_engine = {
      ['rg'] = {
        cmd = 'rg',
        -- default args
        args = {
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
        },
        options = {
          ['ignore-case'] = {
            value = '--ignore-case',
            icon = '[I]',
            desc = 'Ignore case',
          },
          ['hidden'] = {
            value = '--hidden',
            icon = '[H]',
            desc = 'Hidden file',
          },
        }
      }
    },
    default = {
      find = {
        cmd = "rg",
        options = { "hidden" },
      }
    }
  },
  keys = {
    { '<leader>se', function() require('spectre').open() end },
    { '<leader>sf', function() require('spectre').open_file_search() end },
    { '<leader>sw', function() require('spectre').open_file_search({ select_word = true }) end },
  }
}
