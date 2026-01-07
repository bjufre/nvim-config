return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  cmd = "Mason",
  lazy = false,
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    local mr = require("mason-registry")

    -- Ensure required packages
    local required_packages = {
      "vue-language-server",
      -- "typescript-language-server",
      "lua-language-server",
      "html-lsp",
      "css-lsp",
      "tailwindcss-language-server",
      "ruby-lsp",
      "dockerfile-language-server",
      "sqlls",
      "taplo",
      "prettier",
      "stylua",
      "erb-formatter",
      "eslint-lsp",
    }

    -- Refresh registry and install packages asynchronously
    mr.refresh(function()
      for _, pkg_name in ipairs(required_packages) do
        local ok, pkg = pcall(mr.get_package, pkg_name)
        if ok and not pkg:is_installed() then
          vim.notify("Installing " .. pkg_name .. "...", vim.log.levels.INFO)
          pkg:install()
        end
      end
    end)
  end,
}
