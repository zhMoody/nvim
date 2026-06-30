local ok, dap = pcall(require, "dap")
local dapUIOk, dap_ui = pcall(require, "dapui")
local dapVirtualTextOk, dap_virtual_text =
  pcall(require, "nvim-dap-virtual-text")

if dapVirtualTextOk then
  dap_virtual_text.setup { commented = true }
end

vim.fn.sign_define("DapBreakpoint", {
  text = "🛑",
  texthl = "LspDiagnosticsSignError",
  linehl = "",
  numhl = "",
})

vim.fn.sign_define("DapStopped", {
  text = "󰁕",
  texthl = "LspDiagnosticsSignInformation",
  linehl = "DiagnosticUnderlineInfo",
  numhl = "LspDiagnosticsSignInformation",
})

vim.fn.sign_define("DapBreakpointRejected", {
  text = "󰃤",
  texthl = "LspDiagnosticsSignHint",
  linehl = "",
  numhl = "",
})

if dapUIOk and ok then
  dap_ui.setup {
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "o", "<CR>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    layouts = {
      {
        elements = {
          "scopes",
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 10,
        position = "bottom",
      },
    },
    floating = {
      max_height = nil, -- These can be integers or a float between 0 and 1.
      max_width = nil, -- Floats will be treated as percentage of your screen.
      border = "single", -- Border style. Can be "single", "double" or "rounded"
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
    render = {
      max_type_length = nil, -- Can be integer or nil.
      indent = 1,
    },
  }
  dap.listeners.before.attach.dapui_config = dap_ui.open
  dap.listeners.before.launch.dapui_config = dap_ui.open
  dap.listeners.before.event_terminated.dapui_config = dap_ui.close
  dap.listeners.before.event_exited.dapui_config = dap_ui.close

  -- DAP 键映射（直接内联）
  local map = vim.api.nvim_set_keymap
  local opt = { noremap = true, silent = true }
  map("n", "<leader>ds", "<cmd>RustLsp debuggables<CR>", opt)
  map("n", "<leader>dq",
    "<cmd>lua require'dap'.close()<CR>"
    .. ":lua require'dap'.terminate()<CR>"
    .. ":lua require'dap.repl'.close()<CR>"
    .. ":lua require'dapui'.close()<CR>"
    .. ":lua require('dap').clear_breakpoints()<CR>"
    .. "<C-w>o<CR>", opt)
  map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", opt)
  map("n", "<leader>dp", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opt)
  map("n", "<leader>dP", "<cmd>lua require'dap'.clear_breakpoints()<CR>", opt)
  map("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<CR>", opt)
  map("n", "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", opt)
  map("n", "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", opt)
  map("n", "<leader>dh", "<cmd>lua require'dapui'.eval()<CR>", opt)
  map("n", "<leader>dt", "<cmd>lua require'dapui'.toggle()<CR>", opt)
end
