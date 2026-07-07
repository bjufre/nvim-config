return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",

  -- Colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    lazy = false,
    enabled = true,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    enabled = true,
  },
  {
    "olivercederborg/poimandres.nvim",
    lazy = false,
    priority = 1000,
    enabled = true,
  },

  "moll/vim-bbye", -- Better buffer delete and wipeout,

  { "tpope/vim-sleuth", enabled = true },
  { "tpope/vim-abolish", enabled = true },
  "gpanders/editorconfig.nvim",
}
