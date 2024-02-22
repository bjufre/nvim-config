return {
  mode = { "n", "v" },
  -- [";"] = { ":Alpha<CR>", "Dashboard" },
  w = { ":wa!<CR>", "Save" },
  q = { ":confirm q<CR>", "Quit" },
  h = { ":nohlsearch<CR>", "No Highlight" },
  p = { "<CMD>Telescope find_files<CR>", "Find file (CWD)" },
  P = { "<CMD>Telescope find_files no_ignore=true<CR>", "Find file (CWD + `no_ignore`)" },
  v = "Go to definition in a split",
  a = "Swap next param",
  A = "Swap previous param",
  o = { require("telescope.builtin").buffers, "Open Buffer" },
  W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
  Z = { ":ZenMode<CR>", "Toggle ZenMode" },
  -- u = {
  --   name = "UI",
  --   v = { require("config.utils").toggle_set_color_column, "Toggle Color Line" },
  --   c = { require("config.utils").toggle_cursor_line, "Toggle Cursor Line" },
  -- },
  -- i = {
  --   name = "Sessions",
  --   s = { "<cmd>lua require('persistence').load()<cr>", "Load Session" },
  --   l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Load Last Session" },
  --   d = { "<cmd>lua require('persistence').stop()<cr>", "Stop Persistence" },
  -- },
  -- e = {
  --   name = "+NvimTree",
  --   e = { ":NvimTreeToggle<CR>", "Toggle" },
  --   f = { ":NvimTreeFindFile<CR>", "Find File (reveal)" },
  -- },
  e = {
    name = "+Mini Files",
    f = { ":lua require('mini.files').open(vim.api.nvim_buf_get_name(0))<CR>", "Open" },
    e = { ":lua require('mini.files').open()<CR>", "Open (CWD)" },
  },
  s = {
    name = "Replace (Spectre)",
    r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
    w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
    f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
  },
  g = {
    name = "+Git",
    g = { "<cmd>LazyGit<cr>", "Open LazyGit" },
    f = { "<cmd>!git fetch --all<cr>", "Fetch all" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { require("telescope.builtin").git_status, "Open changed file" },
    b = { require("telescope.builtin").git_branches, "Checkout branch" },
    c = { require("telescope.builtin").git_commits, "Checkout commit" },
    C = {
      require("telescope.builtin").git_bcommits,
      "Checkout commit(for current file)",
    },
    d = {
      "<cmd>Gitsigns diffthis HEAD<cr>",
      "Git Diff",
    },
    w = {
      name = "+Worktree",
      l = { require("telescope").extensions.git_worktree.git_worktrees, "List" },
      a = { require("bjufre.worktree.create_worktree"), "Create" },
    },
    -- U = { ":UndotreeToggle<CR>", "Toggle UndoTree" },
  },
  l = {
    name = "+LSP",
    a = { vim.lsp.buf.code_action, "Code Action" },
    A = { vim.lsp.buf.range_code_action, "Range Code Actions" },
    h = { vim.lsp.buf.signature_help, "Display Signature Information" },
    s = { require("telescope.builtin").lsp_document_symbols, "Document Symbols" },
    S = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols" },
    r = { vim.lsp.buf.rename, "Rename all references" },
    f = { vim.lsp.buf.format, "Format" },
    i = { require("telescope.builtin").lsp_implementations, "Implementation" },
    l = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics (Trouble)" },
    L = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics (Trouble)" },
    w = { require("telescope.builtin").diagnostics, "Diagnostics" },
    t = { require("telescope").extensions.refactoring.refactors, "Refactor" },
    R = { require("bjufre.lsp.restart"), "Restart" },
    -- c = { require("config.utils").copyFilePathAndLineNumber, "Copy File Path and Line Number" },

    W = {
      name = "+Workspace",
      a = { vim.lsp.buf.add_workspace_folder, "Add Folder" },
      r = { vim.lsp.buf.remove_workspace_folder, "Remove Folder" },
      l = {
        function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        "List Folders",
      },
    },
  },
  t = {
    name = "+Search",
    f = { "<cmd>Telescope find_files<CR>", "Find File (CWD)" },
    F = { "<cmd>Telescope find_files no_ignore=true<CR>", "Find File (CWD + `no_ignore`)" },
    g = { "<cmd>Telescope git_files<CR>", "Git Files" },
    -- h = { "<cmd>Telescope help_tags<CR>", "Find Help" },
    -- H = { "<cmd>Telescope highlights<CR>", "Find highlight groups" },
    M = { "<cmd>Telescope man_pages<CR>", "Man Pages" },
    o = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
    R = { "<cmd>Telescope registers<CR>", "Registers" },
    t = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
    -- FIXME: Fix issue with `live grep args` not working when invoked
    -- t = { ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", "Live Grep (Args)" },
    T = { "<cmd>Telescope grep_string<CR>", "Grep String" },
    k = { "<cmd>Telescope keymaps<CR>", "Keymaps" },
    C = { "<cmd>Telescope commands<CR>", "Commands" },
    l = { "<cmd>Telescope resume<CR>", "Resume last search" },
    c = { "<cmd>Telescope git_commits<CR>", "Git commits" },
    B = { "<cmd>Telescope git_branches<CR>", "Git branches" },
    m = { "<cmd>Telescope git_status<CR>", "Git status" },
    S = { "<cmd>Telescope git_stash<CR>", "Git stash" },
    -- e = { "<cmd>Telescope frecency<CR>", "Frecency" },
    b = { "<cmd>Telescope buffers<CR>", "Buffers" },
    -- d = {
    --   name = "+DAP",
    --   c = { "<cmd>Telescope dap commands<CR>", "Dap Commands" },
    --   b = { "<cmd>Telescope dap list_breakpoints<CR>", "Dap Breakpoints" },
    --   g = { "<cmd>Telescope dap configurations<CR>", "Dap Configurations" },
    --   v = { "<cmd>Telescope dap variables<CR>", "Dap Variables" },
    --   f = { "<cmd>Telescope dap frames<CR>", "Dap Frames" },
    -- },
  },
  T = {
    name = "+Todo",
    t = { "<cmd>TodoTelescope<CR>", "Todo" },
    T = { "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>", "Todo/Fix/Fixme" },
    x = { "<cmd>TodoTrouble<CR>", "Todo (Trouble)" },
    X = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<CR><CR>", "Todo/Fix/Fixme (Trouble)" },
  },
  -- d = {
  --   name = "Debug",
  --   b = { require("dap").toggle_breakpoint, "Breakpoint" },
  --   c = { require("dap").continue, "Continue" },
  --   i = { require("dap").step_into, "Into" },
  --   o = { require("dap").step_over, "Over" },
  --   O = { require("dap").step_out, "Out" },
  --   r = { require("dap").repl.toggle, "Repl" },
  --   l = { require("dap").run_last, "Last" },
  --   u = { require("dapui").toggle, "UI" },
  --   x = { require("dap").terminate, "Exit" },
  -- },
  -- t = {
  --   name = "+Tests",
  -- },
}