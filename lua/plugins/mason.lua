return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  cmd = "Mason",
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
  config = function()
    local mr = require("mason-registry")

    -- Ensure required packages
    local required_packages = {
      "vue-language-server",
      "typescript-language-server",
      "lua-language-server",
      "html-lsp",
      "css-lsp",
      "tailwindcss-language-server",
      "ruby-lsp",
      "dockerfile-language-server",
      "sqlls",
      "taplo",
      "expert",
      "prettier",
      "stylua",
      "erb-formatter",
      "eslint-lsp",
    }

    for _, pkg in ipairs(required_packages) do
      if not mr.is_installed(pkg) then
        vim.notify("Installing " .. pkg .. "...", vim.log.levels.INFO)
        mr.get_package(pkg):install()
      end
    end
  end,
}

