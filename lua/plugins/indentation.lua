return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = true,
  main = "ibl",
  config = function()
    require("ibl").setup({
      indent = {
        char = "┊",
        smart_indent_cap = true,
      },
      viewport_buffer = { min = 100, max = 500 },
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        show_exact_scope = false,
        injected_languages = true,
      },
      whitespace = {
        remove_blankline_trail = true,
      },
      exclude = {
        filetypes = {
          "slim",
          "lspinfo",
          "packer",
          "checkhealth",
          "help",
          "man",
          "gitcommit",
          "TelescopePrompt",
          "TelescopeResults",
          "",
        },
        buftypes = {
          "terminal",
          "nofile",
          "quickfix",
          "prompt",
        },
      },
    })
  end,
}
