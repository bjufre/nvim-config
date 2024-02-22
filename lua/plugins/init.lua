return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",

  -- Colorscheme
  { "folke/tokyonight.nvim", enabled = true },
  { "rose-pine/neovim", name = "rose-pine", enabled = true },
  { "catppuccin/nvim", name = "catppuccin", enabled = true },
  { "projekt0n/github-nvim-theme", enabled = true },
  { "gbprod/nord.nvim", name = "nord", enabled = true },

  "moll/vim-bbye", -- Better buffer delete and wipeout,

  "norcalli/nvim-colorizer.lua",
  { "tpope/vim-sleuth", enabled = true },
  { "tpope/vim-abolish", enabled = true },
  "gpanders/editorconfig.nvim",
  {
    "kylechui/nvim-surround",
    opts = {},
  },
  {
    "junegunn/vim-easy-align",
    enabled = false,
    keys = {
      {
        "<leader>ea",
        ":EasyAlign*<Bar><Enter>",
      },
    },
  },
}
