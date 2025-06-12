return {
  "nvimdev/lspsaga.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons", -- optional
  },
  config = function()
    require("lspsaga").setup({
      breadcrumbs = {
        enabled = true,
      },
      code_action = {
        num_shortcut = true,
        show_server_name = true,
      },
      implement = {
        enable = true,
      },
      outline = {
        layout = "float",
        keys = {
          toggle_or_jump = "o",
          open = "e",
        },
      },
      finder = {
        keys = {
          toggle_or_open = "<CR>",
          vsplit = "v",
          split = "s",
          tabe = "t",
          tabnew = "T",
          quit = "q",
          close = "<C-c>k",
        },
      },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("bj-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("sd", "<CMD>Lspsaga peek_definition<CR>", "[S]ee [D]efinition")
        map("st", "<CMD>Lspsaga peek_type_definition<CR>", "[S]ee [T]ype [D]efinition")
        map("gd", "<CMD>Lspsaga goto_definition<CR>", "[G]o to [D]efinition")
        map("gt", "<CMD>Lspsaga goto_type_definition<CR>", "[G]oto [T]ype [D]efinition")
        map("gr", "<CMD>Lspsaga finder ref<CR>", "[G]o to [R]eferences")
        map("gi", "<CMD>Lspsaga finder imp<CR>", "[G]o to [I]mplementation")
        map("do", "<CMD>Lspsaga outline<CR>", "[D]ocument [O]utline")
        map("<leader>rn", "<CMD>Lspsaga rename<CR>", "[R]e[n]ame")
        map("<leader>ca", "<CMD>Lspsaga code_action<CR>", "[C]ode [A]ction")
        -- map("K", "<CMD>Lspsaga hover_doc<CR>", "Hover Documentation")
        map("K", function()
          local is_diagnostic = require("bjufre.lsp").is_diagnostic()
          if is_diagnostic == true then
            local bufnr, win_id = vim.diagnostic.open_float({
              scope = "cursor",
              focusable = true,
              border = "rounded",
              max_width = 80,
              max_height = 20,
              wrap = true,
            })

            if win_id then
              -- Set up keymaps for the floating window
              local opts = { buffer = bufnr, nowait = true, silent = true }
              vim.keymap.set("n", "q", "<cmd>close<cr>", opts) -- Close with 'q'
              vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", opts) -- Close with Escape

              -- Focus the floating window
              vim.api.nvim_set_current_win(win_id)
            end
          else
            vim.cmd("Lspsaga hover_doc")
          end
        end, "Hover/Diagnostic")
        -- CUSTOM restart function
        map("<leader>lr", require("bjufre.lsp").restart, "[R]estart")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })
  end,
}
