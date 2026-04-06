vim.g.mapleader = " "
vim.g.maplocalleader = ","

local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

map("i", "kj", "<Esc>", opt)
map("i", "jk", "<Esc>", opt)
map("i", "kk", "<Esc>", opt)
map("i", "jj", "<Esc>", opt)

map("i", "<C-f>", "<Right>", opt)
map("i", "<C-b>", "<Left>", opt)
map("i", "<C-p>", "<Up>", opt)
map("i", "<C-n>", "<Down>", opt)
map("i", "<C-e>", "<End>", opt)
map("i", "<C-a>", "<C-o>I", opt)

map("v", "v", "<Esc>", opt)
-- map("v", "[", "<gv", opt)
-- map("v", "]", ">gv", opt)

map("n", "<A-]>", "<C-w>+", opt)
map("n", "<A-[>", "<C-w>-", opt)
map("n", "<A-h>", "<C-w><", opt)
map("n", "<A-l>", "<C-w>>", opt)

-- 终端模式下也能调整窗口大小
map("t", "<A-]>", "<C-\\><C-n><C-w>+i", opt)
map("t", "<A-[>", "<C-\\><C-n><C-w>-i", opt)
map("t", "<A-h>", "<C-\\><C-n><C-w><i", opt)
map("t", "<A-l>", "<C-\\><C-n><C-w>>i", opt)

map("n", "<C-u>", "9k", opt)
map("n", "<C-d>", "9j", opt)
map("n", "<S-Tab>", "<cmd>bprevious<CR>", opt)
map("n", "<Tab>", "<cmd>bnext<CR>", opt)
-- map("t", "<localleader>tt", "<C-\\><C-n><cmd>Lspsaga term_toggle<CR>", opt)

map("n", "<C-k>", "<C-w>k", opt)

map("n", "<C-l>", "<C-w>l", opt)
map("n", "<C-j>", "<C-w>j", opt)
map("n", "<C-h>", "<C-w>h", opt)

-- 终端模式下也能切换窗口
map("t", "<C-k>", "<C-\\><C-n><C-w>k", opt)
map("t", "<C-l>", "<C-\\><C-n><C-w>l", opt)
map("t", "<C-j>", "<C-\\><C-n><C-w>j", opt)
map("t", "<C-h>", "<C-\\><C-n><C-w>h", opt)

vim.keymap.set("n", "<localleader>c", function()
  if vim.o.background == "light" then
    vim.o.background = "dark"
  else
    vim.o.background = "light"
  end
end, { expr = true, noremap = true, replace_keycodes = false })

if vim.g.neovide then
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  map("!", "<D-v>", "<C-R>+", opt)
end

local M = {}

M.telescope_keys = {
  i = {
    ["<C-u>"] = "preview_scrolling_up",
    ["<C-d>"] = "preview_scrolling_down",
    ["<C-n>"] = "move_selection_next",
    ["<C-p>"] = "move_selection_previous",
  },
  n = {
    ["<C-u>"] = "preview_scrolling_up",
    ["<C-d>"] = "preview_scrolling_down",
    ["<C-n>"] = "move_selection_next",
    ["<C-p>"] = "move_selection_previous",
  },
}

M.map_lsp = function(buf)
  -- buf("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
  buf("n", "K", "<cmd>Lspsaga hover_doc<CR>", opt)
  buf("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opt)
  buf("n", "<localleader>gp", "<cmd>Lspsaga peek_definition<CR>", opt)
  buf("n", "gr", "<cmd>Lspsaga finder<CR>", opt)
  buf("n", "gn", "<cmd>Lspsaga diagnostic_jump_next<CR>", opt)
  buf("n", "gp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opt)
  buf("n", "<localleader>dw", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opt)
  buf("n", "<localleader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", opt)
  buf(
    "n",
    "<localleader>dd",
    "<cmd>lua vim.diagnostic.open_float(nil, { focus = false })<CR>",
    opt
  )
  buf("n", "<leader>lc", "<cmd>Lspsaga code_action<CR>", opt)
end

M.map_xcodebuild = function(buf)
  buf("n", "<localleader>ss", "<cmd>XcodebuildSetup<cr>", opt)
  buf("n", "<localleader>sr", "<cmd>XcodebuildBuildRun<cr>", opt)
end

M.cmp = function(c)
  return {
    ["<A-.>"] = c.mapping(c.mapping.complete(), { "i", "c" }),
    ["<A-,>"] = c.mapping {
      i = c.mapping.abort(),
      c = c.mapping.close(),
    },
    ["<C-p>"] = c.mapping.select_prev_item(),
    ["<C-n>"] = c.mapping.select_next_item(),
    ["<CR>"] = c.mapping.confirm {
      select = true,
    },
    ["<Tab>"] = c.mapping.confirm {
      select = true,
    },
  }
end

M.comment = {
  opleader = {
    line = "gc",
    bock = "gb",
  },
}

M.map_flutter_tools = function(bufnr)
  local flutter_cmds = {
    { text = "󰐊 Run App", cmd = "FlutterRun" },
    { text = "󰜉 Hot Reload", cmd = "FlutterReload" },
    { text = "󰜐 Hot Restart", cmd = "FlutterRestart" },
    { text = "󰗼 Quit", cmd = "FlutterQuit" },
    { text = "󱔗 List Devices", cmd = "FlutterDevices" },
    { text = "󰛵 List Emulators", cmd = "FlutterEmulators" },
    { text = "󱠂 Open DevTools", cmd = "FlutterDevTools" },
    { text = "󰙨 View Log", cmd = "FlutterLog" },
    { text = "󱖫 Toggle Outline", cmd = "FlutterOutlineToggle" },
  }

  vim.keymap.set("n", "<leader>ac", function()
    vim.ui.select(flutter_cmds, {
      prompt = "Flutter Commands",
      format_item = function(item)
        return item.text
      end,
    }, function(item)
      if item then
        vim.cmd(item.cmd)
      end
    end)
  end, {
    buffer = bufnr,
    noremap = true,
    silent = true,
    desc = "Flutter Commands",
  })
end

M.map_rust_dap = function()
  map("n", "<leader>ds", "<cmd>RustLsp debuggables<CR>", opt)
  map(
    "n",
    "<leader>dq",
    "<cmd>lua require'dap'.close()<CR>"
      .. ":lua require'dap'.terminate()<CR>"
      .. ":lua require'dap.repl'.close()<CR>"
      .. ":lua require'dapui'.close()<CR>"
      .. ":lua require('dap').clear_breakpoints()<CR>"
      .. "<C-w>o<CR>",
    opt
  )
  map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", opt)
  map("n", "<leader>dp", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opt)
  map("n", "<leader>dP", "<cmd>lua require'dap'.clear_breakpoints()<CR>", opt)
  map("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<CR>", opt)
  map("n", "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", opt)
  map("n", "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", opt)
  map("n", "<leader>dh", "<cmd>lua require'dapui'.eval()<CR>", opt)
  map("n", "<leader>dt", "<cmd>lua require'dapui'.toggle()<CR>", opt)
end

-- === Snacks Keybindings ===

-- 离开终端窗口自动退出 insert 模式，这样切换到其他窗口后快捷键立即可用
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("stopinsert")
    end
  end,
})

-- 底部终端分屏管理
local tt_windows = {}  -- 存储底部分屏的所有窗口

vim.keymap.set({ "n", "t" }, "<leader>tt", function()
  -- 检查是否有底部分屏窗口存在
  local has_valid_window = false
  for _, win in ipairs(tt_windows) do
    if vim.api.nvim_win_is_valid(win) then
      has_valid_window = true
      break
    end
  end

  if has_valid_window then
    -- 关闭所有底部分屏窗口及其 buffer
    for _, win in ipairs(tt_windows) do
      if vim.api.nvim_win_is_valid(win) then
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_win_close(win, false)
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end
    tt_windows = {}
  else
    -- 创建新的底部分屏
    vim.cmd("botright split")
    vim.cmd("resize 15")
    vim.cmd("terminal")
    vim.bo.buflisted = false  -- 不在标签栏显示
    vim.cmd("startinsert")
    table.insert(tt_windows, vim.api.nvim_get_current_win())
  end
end, { desc = "切换底部终端分屏" })

-- 右侧终端分屏管理
local tr_windows = {}  -- 存储右侧分屏的所有窗口

vim.keymap.set({ "n", "t" }, "<leader>tr", function()
  -- 检查是否有右侧分屏窗口存在
  local has_valid_window = false
  for _, win in ipairs(tr_windows) do
    if vim.api.nvim_win_is_valid(win) then
      has_valid_window = true
      break
    end
  end

  if has_valid_window then
    -- 关闭所有右侧分屏窗口及其 buffer
    for _, win in ipairs(tr_windows) do
      if vim.api.nvim_win_is_valid(win) then
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_win_close(win, false)
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end
    tr_windows = {}
  else
    -- 创建新的右侧分屏
    vim.cmd("botright vsplit")
    vim.cmd("terminal")
    vim.bo.buflisted = false  -- 不在标签栏显示
    vim.cmd("startinsert")
    table.insert(tr_windows, vim.api.nvim_get_current_win())
  end
end, { desc = "切换右侧终端分屏" })

-- 辅助函数：判断当前窗口属于哪个分屏组
local function get_split_group()
  local current_win = vim.api.nvim_get_current_win()

  -- 检查是否在 tt 分屏组
  for _, win in ipairs(tt_windows) do
    if win == current_win then
      return "tt", tt_windows
    end
  end

  -- 检查是否在 tr 分屏组
  for _, win in ipairs(tr_windows) do
    if win == current_win then
      return "tr", tr_windows
    end
  end

  return nil, nil
end

-- 导出函数供 which-key 使用
_G.split_in_terminal_group = function(direction)
  local group, windows = get_split_group()

  if group then
    -- 在终端分屏组内分割
    if direction == "h" then
      vim.cmd("vsplit")
    else
      vim.cmd("split")
    end
    vim.cmd("terminal")
    vim.bo.buflisted = false  -- 不在标签栏显示
    vim.cmd("startinsert")
    table.insert(windows, vim.api.nvim_get_current_win())
  else
    -- 普通窗口，正常分割
    if direction == "h" then
      vim.cmd("vsp")
    else
      vim.cmd("sp")
    end
  end
end

-- 打开 Lazygit
vim.keymap.set("n", "<leader>gg", function()
  require("snacks").lazygit()
end, { desc = "Lazygit" })

-- 终端模式下单次 ESC 退出到 normal 模式
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- === Markdown Keybindings ===
vim.keymap.set("n", "<leader>mt", "<cmd>RenderMarkdown toggle<CR>", { desc = "Markdown Toggle" })

return M
