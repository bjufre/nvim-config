return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",

  -- Colorscheme
  "folke/tokyonight.nvim",
  { "projekt0n/github-nvim-theme", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = true },
  { "rose-pine/neovim", name = "rose-pine", enabled = true },
  "rebelot/kanagawa.nvim",
  { "olivercederborg/poimandres.nvim", enabled = false },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
  },
  { "shaunsingh/nord.nvim" },

  "moll/vim-bbye", -- Better buffer delete and wipeout,

  { "tpope/vim-sleuth", enabled = true },
  "tpope/vim-abolish",
  "gpanders/editorconfig.nvim",
  {
    "kylechui/nvim-surround",
    opts = {},
  },
  {
    "junegunn/vim-easy-align",
    keys = {
      {
        "<leader>ea",
        ":EasyAlign*<Bar><Enter>",
      },
    },
  },

  -- Github
  { "github/copilot.vim", enabled = false },
  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>" },
      { "<leader>gf", "<cmd>!git fetch --all<CR>" },
    },
  },
}
