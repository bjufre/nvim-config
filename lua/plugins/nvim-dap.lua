return {
  enabled = true,
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    -- Install the vscode-js-debug adapter
    {
      "microsoft/vscode-js-debug",
      -- After install, build it and rename the dist directory to out
      build = "npm install --legacy-peer-deps --no-save && npx gulp dapDebugServer && rm -rf out && mv dist out",
      version = "1.*",
    },
    {
      "Joakker/lua-json5",
      build = "./install.sh",
    },
  },
  config = function()
    local js_based_languages = {
      "typescript",
      "javascript",
      "typescriptreact",
      "javascriptreact",
      "vue",
    }
    local remap = require("bjufre.keymaps").remap
    local dap = require("dap")
    local dapui = require("dapui")

    require("nvim-dap-virtual-text").setup({
      display_callback = function(variable, buf, stackframe, node, options)
        -- by default, strip out new line characters
        if options.virt_text_pos == "inline" then
          return " = " .. variable.value:gsub("%s+", " ")
        else
          return variable.name .. " = " .. variable.value:gsub("%s+", " ")
        end
      end,
      -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
      virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
    })

    -- Path to the vscode-js-debug adapter
    local js_debug_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug")

    dap.adapters["pwa-node"] = {}

    -- Manually configure the adapters using the built vscode-js-debug
    for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "node-terminal" }) do
      dap.adapters[adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            js_debug_path .. "/out/src/dapDebugServer.js",
            "${port}",
          },
        },
      }
    end

    local get_url = function()
      local url = vim.fn.input("Enter URL: ", "http://localhost:3000")
      vim.cmd('echo ""')
      return url
    end

    for _, language in ipairs(js_based_languages) do
      dap.configurations[language] = {
        -- Debug single nodejs files
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file pwa-node (nvim-dap)",
          program = "${file}",
          sourceMaps = true,
          cwd = "${workspaceFolder}",
        },
        -- Debug nodejs processes (make sure to add --inspect when you run the process)
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach pwa-node (nvim-dap)",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        -- Debug web applications (client side)
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch & Debug Chrome (nvim-dap)",
          url = get_url,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
        -- Divider for the launch.json derived configs
        -- {
        --   name = "----- ↓ launch.json configs ↓ -----",
        --   type = "",
        --   request = "launch",
        -- },
      }
    end

    dapui.setup()

    -- Define DAP signs using icons (matching LazyVim style)
    local icons = require("bjufre.icons")
    vim.fn.sign_define("DapBreakpoint", { text = icons.ui.BigCircle, texthl = "DiagnosticInfo" })
    vim.fn.sign_define("DapBreakpointCondition", { text = icons.ui.BigCircle, texthl = "DiagnosticInfo" })
    vim.fn.sign_define("DapBreakpointRejected", { text = icons.ui.BigCircle, texthl = "DiagnosticError" })
    vim.fn.sign_define("DapLogPoint", { text = ".>", texthl = "DiagnosticInfo" })
    vim.fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine" })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    remap("n", "<leader>dt", dap.toggle_breakpoint)
    remap("n", "<leader>do", dap.step_over)
    remap("n", "<leader>di", dap.step_into)
    remap("n", "<leader>dB", dap.step_back)
    remap("n", "<leader>dO", dap.step_out)
    remap("n", "<leader>dc", dap.close)
    remap("n", "<leader>dr", dap.repl.open)
    remap("n", "<leader>dR", dap.restart)
    remap("n", "<leader>duu", dapui.open)
    remap("n", "<leader>duc", dapui.close)
    remap("n", "<leader>dk", dap.terminate)
    remap("n", "?", function()
      dapui.eval(nil, { enter = true })
    end)
    remap("n", "<leader>dc", dap.continue)
    remap("n", "<leader>da", function()
      if vim.fn.filereadable(".vscode/launch.json") then
        local dap_vscode = require("dap.ext.vscode")
        dap_vscode.load_launchjs(nil, {
          ["pwa-node"] = js_based_languages,
          ["chrome"] = js_based_languages,
          ["pwa-chrome"] = js_based_languages,
        })
      end
      dap.continue()
    end)
  end,
}
