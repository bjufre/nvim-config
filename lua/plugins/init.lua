return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",

  -- Colorscheme
  { "folke/tokyonight.nvim", enabled = true },
  { "rose-pine/neovim", name = "rose-pine", enabled = true },
  { "catppuccin/nvim", name = "catppuccin", enabled = true },
  {
    "olivercederborg/poimandres.nvim",
    lazy = false,
    priority = 1000,
    enabled = true,
  },
  {
    "bettervim/yugen.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
  },
  { "gbprod/nord.nvim", name = "nord", enabled = true },
  { "AlexvZyl/nordic.nvim", name = "nordic", enabled = true },

  "moll/vim-bbye", -- Better buffer delete and wipeout,

  { "tpope/vim-sleuth", enabled = true },
  { "tpope/vim-abolish", enabled = true },
  "gpanders/editorconfig.nvim",
}
