return {
  "kyazdani42/nvim-tree.lua",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },
  enabled = false,
  lazy = false,
  keys = {
    { "<leader>ff", "<cmd>NvimTreeFindFile<cr>", desc = "Find File in File Tree" },
    { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Tree" },
  },
  opts = {
    filters = {
      custom = { ".git", "node_modules", ".vscode" },
      dotfiles = true,
    },
    git = {},
    view = {
      adaptive_size = true,
      float = {
        enable = true,
      },
    },
  },
}
