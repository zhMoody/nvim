vim.g.mapleader = " "
vim.g.maplocalleader = ","

local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

-- Escape insert mode: kj, jk, kk, jj
map("i", "kj", "<Esc>", opt)
map("i", "jk", "<Esc>", opt)
map("i", "kk", "<Esc>", opt)
map("i", "jj", "<Esc>", opt)

-- Insert mode navigation
map("i", "<C-f>", "<Right>", opt)
map("i", "<C-b>", "<Left>", opt)
map("i", "<C-p>", "<Up>", opt)
map("i", "<C-n>", "<Down>", opt)
map("i", "<C-e>", "<End>", opt)
map("i", "<C-a>", "<C-o>I", opt)

-- Visual mode: escape
map("v", "v", "<Esc>", opt)

-- Window size (normal + terminal)
vim.keymap.set({ "n", "t" }, "<A-]>", function()
  if vim.fn.mode() == "t" then vim.cmd("stopinsert") end
  vim.cmd("resize +1")
end, opt)
vim.keymap.set({ "n", "t" }, "<A-[>", function()
  if vim.fn.mode() == "t" then vim.cmd("stopinsert") end
  vim.cmd("resize -1")
end, opt)
vim.keymap.set({ "n", "t" }, "<A-h>", function()
  if vim.fn.mode() == "t" then vim.cmd("stopinsert") end
  vim.cmd("vertical resize -1")
end, opt)
vim.keymap.set({ "n", "t" }, "<A-l>", function()
  if vim.fn.mode() == "t" then vim.cmd("stopinsert") end
  vim.cmd("vertical resize +1")
end, opt)

-- Fast scroll
map("n", "<C-u>", "9k", opt)
map("n", "<C-d>", "9j", opt)

-- Buffer navigation
map("n", "<S-Tab>", "<cmd>bprevious<CR>", opt)
map("n", "<Tab>", "<cmd>bnext<CR>", opt)

-- Window navigation (normal + terminal)
for _, mode in ipairs({ "n", "t" }) do
  for dir, key in pairs({ k = "k", j = "j", h = "h", l = "l" }) do
    local cmd = "<C-\\><C-n><C-w>" .. key
    vim.keymap.set(mode, "<C-" .. dir .. ">", cmd, opt)
  end
end

-- Colorscheme toggle
vim.keymap.set("n", "<localleader>c", function()
  require("themes").picker()
end, { desc = "切换主题" })

-- Neovide paste
if vim.g.neovide then
  vim.keymap.set("c", "<D-v>", "<C-R>+")
  map("!", "<D-v>", "<C-R>+", opt)
end

-- Terminal: ESC → normal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", opt)

-- WinLeave: stopinsert in terminal
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("stopinsert")
    end
  end,
})

-- === 导出给其他模块调用的 keymap 函数 ===
local M = {}

-- LSP 键映射（被 lang/lsp-handlers.lua 调用）
M.map_lsp = function(buf)
  local function buf_map(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, noremap = true, silent = true, desc = opts })
  end
  buf_map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover")
  buf_map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", "Go to Definition")
  buf_map("n", "<localleader>gp", "<cmd>Lspsaga peek_definition<CR>", "Peek Definition")
  buf_map("n", "gr", "<cmd>Lspsaga finder<CR>", "References")
  buf_map("n", "gn", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next Diagnostic")
  buf_map("n", "gp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev Diagnostic")
  buf_map("n", "<localleader>dw", "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Cursor Diagnostics")
  buf_map("n", "<localleader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostics")
  buf_map("n", "<localleader>dd", "<cmd>lua vim.diagnostic.open_float(nil, { focus = false })<CR>", "Float Diagnostics")
  buf_map("n", "<leader>lc", "<cmd>Lspsaga code_action<CR>", "Code Action")
end

-- Xcodebuild 键映射（被 lang/swift.lua 调用）
M.map_xcodebuild = function(buf)
  vim.keymap.set("n", "<localleader>ss", "<cmd>XcodebuildSetup<cr>", { buffer = buf, noremap = true, silent = true, desc = "Xcode Setup" })
  vim.keymap.set("n", "<localleader>sr", "<cmd>XcodebuildBuildRun<cr>", { buffer = buf, noremap = true, silent = true, desc = "Xcode Build & Run" })
end

-- Flutter 命令菜单（被 lang/flutter.lua 调用）
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
      format_item = function(item) return item.text end,
    }, function(item)
      if item then vim.cmd(item.cmd) end
    end)
  end, { buffer = bufnr, noremap = true, silent = true, desc = "Flutter Commands" })
end

-- CMP 键映射（被 lang/completion.lua 调用）
M.cmp = function(c)
  return {
    ["<A-.>"] = c.mapping(c.mapping.complete(), { "i", "c" }),
    ["<A-,>"] = c.mapping { i = c.mapping.abort(), c = c.mapping.close() },
    ["<C-p>"] = c.mapping.select_prev_item(),
    ["<C-n>"] = c.mapping.select_next_item(),
    ["<CR>"] = c.mapping.confirm { select = true },
    ["<Tab>"] = c.mapping.confirm { select = true },
  }
end

-- Telescope 键映射（被 file/telescope.lua 调用）
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

return M
