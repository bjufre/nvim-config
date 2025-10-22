-- require("bjufre.themes.tokyonight")
-- require("bjufre.themes.catppuccin")
-- require("bjufre.themes.kanso")
-- require("bjufre.themes.poimandres")
-- require("bjufre.themes.nord")
require("bjufre.themes.rose-pine")

-- Configure Vue component highlighting
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- Link Vue component type to regular type for better highlighting
    vim.api.nvim_set_hl(0, "@lsp.type.component", { link = "@type" })
  end,
})
