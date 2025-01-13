return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",

  -- Colorscheme
  { "folke/tokyonight.nvim", enabled = true },
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
  {
    "gbprod/nord.nvim",
    name = "nord",
    lazy = false,
    priority = 1000,
    enabled = true,
  },

  "moll/vim-bbye", -- Better buffer delete and wipeout,

  { "tpope/vim-sleuth", enabled = true },
  { "tpope/vim-abolish", enabled = true },
  "gpanders/editorconfig.nvim",
}
