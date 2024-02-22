return {
  "nvim-neotest/neotest",
  dependencies = {
    "folke/which-key.nvim",

    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    -- ADAPTERS
    "marilari88/neotest-vitest",
    "olimorris/neotest-rspec",
    "jfpedroza/neotest-elixir",
    -- "theutz/neotest-pest", -- PHP
    -- "rouge8/neotest-rust",
    -- "nvim-neotest/neotest-go",
    -- "lawrence-laz/neotest-zig",
  },
  config = function()
    require("neotest").setup({
      library = { plugins = { "neotest" }, types = true },
      adapters = {
        require("neotest-vitest"),
        -- require("neotest-rspec"),
        require("neotest-rspec")({
          rspec_cmd = function()
            return vim.tbl_flatten({
              "zeus",
              "test",
            })
          end,
        }),
        require("neotest-elixir"),
        -- require('neotest-pest'),
        -- require("neotest-rust"),
        -- require("neotest-go"),
        -- require("neotest-zig"),
      },
      summary = {
        enabled = true,
        animated = true,
        follow = true,
        expand_errors = true,
      },
      status = {
        enabled = true,
        signs = true,
        virtual_text = false,
      },
    })

    require("which-key").register({
      t = {
        name = "+Neotest",
        s = { require("neotest").summary.toggle, "Toggle summary" },
        o = {
          function()
            require("neotest").output.open({ enter = true, short = false })
          end,
          "Open Output",
        },
        O = {
          function()
            require("neotest").output_panel.toggle({
              enter = true,
              short = false,
            })
          end,
          "Toggle output panel",
        },
        t = { require("neotest").run.run, "Run nearest test" },
        f = {
          function()
            require("neotest").run.run(vim.fn.expand("%"))
          end,
          "Run file",
        },
        l = { require("neotest").run.run_last, "Run last test command" },
        x = { require("neotest").run.stop, "Run cancel" },
      },
    })
  end,
}
