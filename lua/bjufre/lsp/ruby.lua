local M = {}

M.setup = function(on_attach)
  local lspconfig = require("lspconfig")
  local configs = require("lspconfig.configs")

  configs.fuzzy_ls = {
    default_config = {
      -- cmd = { "fuzzy" },
      cmd = { "/Users/bj/fuzzy_ruby_server/target/release/fuzzy" },
      filetypes = { "ruby" },
      root_dir = function(fname)
        return lspconfig.util.find_git_ancestor(fname)
      end,
      settings = {},
      init_options = {
        allocationType = "ram",
        indexGems = true,
        reportDiagnostics = true,
      },
    },
  }

  configs.fuzzy_ls.setup({
    on_attach = on_attach,
  })
end

return M
