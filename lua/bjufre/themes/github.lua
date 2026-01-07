require("github_plus").setup({
  terminal_colors = true, -- Enables terminal color highlighting
  transparent = false, -- Disables transparent background by default
  styles = {
    comments = {
      italic = true, -- Italic comments
    },
  },
})

vim.cmd([[colorscheme github_plus]])
