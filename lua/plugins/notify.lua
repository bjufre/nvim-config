return {
  'rcarriga/nvim-notify',
  config = function()
    local log = require('plenary.log').new {
      level = 'debug',
      plugin = 'notify',
      use_console = false,
    }

    local notify = require('notify')

    notify.setup({
      timeout = 1000,
      max_width = 80,
      opacity = 70,
      background_colour = '#000000',
    })

    vim.notify = function(msg, level, opts)
      log.info(msg, level, opts)

      require('notify')(msg, level, opts)
    end
  end
}
