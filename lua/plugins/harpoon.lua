return {
  'ThePrimeagen/harpoon',
  opts = {
    global_settings = {
      -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
      save_on_toggle = false,
      -- saves the harpoon file upon every change. disabling is unrecommended.
      save_on_change = true,
      -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
      enter_on_sendcmd = false,
      -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
      tmux_autoclose_windows = false,
      -- filetypes that you want to prevent from adding to the harpoon list menu.
      excluded_filetypes = { "harpoon" },
      -- set marks specific to each git branch inside git repository
      mark_branch = true,
    }
  },
  keys = {
    { '<leader>hh', function() require('harpoon.mark').add_file() end },
    { '<leader>hu', function() require('harpoon.ui').toggle_quick_menu() end },
    { '<C-n>', function() require('harpoon.ui').nav_file(1) end },
    { '<C-e>', function() require('harpoon.ui').nav_file(2) end },
    { '<C-i>', function() require('harpoon.ui').nav_file(3) end },
    { '<C-o>', function() require('harpoon.ui').nav_file(4) end },
    { '<C-\'>', function() require('harpoon.ui').nav_file(5) end },
  }
}
