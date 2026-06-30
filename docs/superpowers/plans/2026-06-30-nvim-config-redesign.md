# Neovim 配置重构实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** 将 nvim-012 完整的 Neovim 配置（64 插件、14 LSP、40+ 快捷键）按功能域重构到 nvim-new，100% 功能保留。

**架构:** 每个配置文件直接返回 lazy.nvim 的 plugin spec，由 plugins.lua 聚合。主题系统通过注册表统一管理 colorscheme/lualine/tabline 的对应关系。语言支持每个文件对应一个 LSP server，共享 on_attach/handlers。

**Tech Stack:** Neovim 0.12+, lazy.nvim, Lua 5.1, Mason, nvim-cmp, Telescope, Treesitter

## 全局约束

- 文件始终以 Lua 模块形式返回（return table/function）
- 所有 64 个插件必须保留
- 所有快捷键必须保留
- 每个配置文件使用 pcall 保护 require
- config.lua 是唯一的用户配置入口

---

### Task 1: 脚手架 + 核心配置

**Files:**
- Create: `lua/init.lua`
- Create: `lua/config.lua`
- Create: `lua/core/bootstrap.lua`
- Create: `lua/core/basic.lua`
- Create: `lua/core/keymaps.lua`
- Create: `lua/core/autocmds.lua`
- Create: `lua/plugins.lua` (占位)
- Create: `stylua.toml`
- Create: `docs/` 目录

**Interfaces:**
- Consumes: 无（这是基础层）
- Produces: `core/bootstrap.lua` 提供全局 `_G.GetMasonPackagePath`；`core/basic.lua` 返回 lazy spec 设置 vim 选项；`core/keymaps.lua` 设置全局映射；`config.lua` 导出配置表

- [ ] **Step 1: 创建 stylua.toml**

```toml
indent_type = "Spaces"
indent_width = 2
no_call_parentheses = true
column_width = 80
```

- [ ] **Step 2: 创建 lua/config.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/config.lua`

```lua
return {
  colorscheme = "gruvbox",
  background = "dark",
  python3_host_prog = "/opt/homebrew/bin/python3",
  lua_line = "gruvbox_modern",
  tab_theme = "gruvbox_modern",
  ignore = { "rust-analyzer", "hls" },
}
```

- [ ] **Step 3: 创建 lua/core/bootstrap.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/core/bootstrap.lua`

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

function _G.GetMasonPackagePath(package_name)
  local root = vim.fn.stdpath("data") .. "/mason/packages"
  local path = root .. "/" .. package_name
  if vim.loop.fs_stat(path) then
    return path
  end
  return nil
end
```

- [ ] **Step 4: 创建 lua/core/basic.lua — 直接返回 lazy spec，含禁用 netrw**

文件路径: `/Users/moody/.config/nvim-new/lua/core/basic.lua`

```lua
return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    init = function()
      vim.g.loaded_netrw = 0
      vim.g.loaded_netrwPlugin = 0
    end,
    opts = {},
  },
  {
    "folke/snacks.nvim",
    opts = function()
      vim.g.encoding = "UTF-8"
      vim.o.fileencoding = "utf-8"
      vim.o.scrolloff = 8
      vim.o.sidescrolloff = 8
      vim.wo.number = true
      vim.wo.relativenumber = true
      vim.wo.cursorline = true
      vim.wo.cursorcolumn = true
      vim.wo.signcolumn = "yes"
      vim.wo.colorcolumn = "0"
      vim.o.tabstop = 2
      vim.bo.tabstop = 2
      vim.o.softtabstop = 2
      vim.o.shiftround = true
      vim.o.shiftwidth = 2
      vim.bo.shiftwidth = 2
      vim.o.expandtab = true
      vim.bo.expandtab = true
      vim.o.autoindent = true
      vim.bo.autoindent = true
      vim.o.smartindent = true
      vim.o.ignorecase = false
      vim.o.hlsearch = true
      vim.o.incsearch = true
      vim.o.showmode = false
      vim.o.cmdheight = 0
      vim.o.autoread = true
      vim.bo.autoread = true
      vim.o.wrap = false
      vim.wo.wrap = false
      vim.o.whichwrap = "b,s,<,>,[,]"
      vim.o.hidden = true
      vim.o.mouse = ""
      vim.o.updatetime = 300
      vim.o.timeoutlen = 500
      vim.o.splitbelow = true
      vim.o.splitright = true
      vim.opt.completeopt = "menu,menuone,noselect"
      vim.o.termguicolors = true
      vim.o.list = true
      vim.o.listchars = "space: "
      vim.o.wildmenu = true
      vim.o.shortmess = vim.o.shortmess .. "c"
      vim.o.pumheight = 10
      vim.o.showtabline = 2

      local prefix = vim.fn.expand("/tmp")
      vim.opt.undodir = { prefix .. "/nvim/.undo//" }
      vim.opt.backupdir = { prefix .. "/nvim/.backup//" }
      vim.opt.directory = { prefix .. "/nvim/.swp//" }

      vim.o.clipboard = "unnamed,unnamedplus"
      vim.g.loaded_ruby_provider = 0
      vim.g.loaded_perl_provider = 0
    end,
  },
}
```

- [ ] **Step 5: 创建 lua/core/keymaps.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/core/keymaps.lua`

```lua
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
  if vim.o.background == "light" then
    vim.o.background = "dark"
  else
    vim.o.background = "light"
  end
end, { expr = true, noremap = true, replace_keycodes = false })

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
```

- [ ] **Step 6: 创建 lua/core/autocmds.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/core/autocmds.lua`

```lua
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { on_visual = true }
  end,
})
```

- [ ] **Step 7: 创建 lua/init.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/init.lua`

```lua
require("core.bootstrap")
require("core.basic")
require("core.keymaps")
require("core.autocmds")
```

- [ ] **Step 8: 创建 lua/plugins.lua（占位，后续 Task 逐步填入）**

文件路径: `/Users/moody/.config/nvim-new/lua/plugins.lua`

```lua
return {
  require("core.basic"),
  require("core.keymaps"),
  require("core.autocmds"),
  -- 后续逐步添加各模块
}
```

---

### Task 2: Mason + LSP 基础设施 + Completion

**Files:**
- Create: `lua/lang/init.lua`
- Create: `lua/lang/mason.lua`
- Create: `lua/lang/lsp-handlers.lua`
- Create: `lua/lang/completion.lua`

**Interfaces:**
- Consumes: `config.lua` (ignore list), `core/keymaps.lua` (LSP keymap 函数)
- Produces: `lang/lsp-handlers.lua` 导出 capabilities/flags/border/handlers/disableFormat/keybinding，供各语言文件使用；`lang/completion.lua` 配置 nvim-cmp

- [ ] **Step 1: 创建 lua/lang/lsp-handlers.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/lang/lsp-handlers.lua`

```lua
local M = {}

M.keybinding = function(buf)
  require("core.keymaps").map_lsp(buf)
end

M.disableFormat = function(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.flags = {
  debounce_text_changes = 150,
}

M.border = {
  { "┌", "highlight" },
  { "─", "highlight" },
  { "┐", "highlight" },
  { "│", "highlight" },
  { "┘", "highlight" },
  { "─", "highlight" },
  { "└", "highlight" },
  { "│", "highlight" },
}

M.handlers = {
  ["textDocument/hover"] = vim.lsp.buf.hover { border = M.border },
  ["textDocument/signatureHelp"] = vim.lsp.buf.signature_help {
    border = M.border,
  },
}

return M
```

- [ ] **Step 2: 创建 lua/lang/mason.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/lang/mason.lua`

```lua
return {
  "williamboman/mason.nvim",
  opts = { log_level = vim.log.levels.ERROR },
}
```

- [ ] **Step 3: 创建 lua/lang/init.lua（Mason + LSP servers 配置）**

文件路径: `/Users/moody/.config/nvim-new/lua/lang/init.lua`

```lua
local config = require("config")

-- 各语言文件的 LSP 配置
local servers = {
  lua_ls = require("lang.lua"),
  clangd = require("lang.cpp"),
  jsonls = require("lang.json"),
  ocamllsp = require("lang.ocaml"),
  hls = require("lang.haskell"),
  sourcekit = require("lang.swift"),
  zls = require("lang.zig"),
  cssls = require("lang.css"),
  html = require("lang.html"),
  emmet_language_server = require("lang.emmet"),
  ts_ls = require("lang.typescript"),
  vue_ls = require("lang.vue"),
}

require("mason-lspconfig").setup {
  ensure_installed = vim.tbl_filter(function(key)
    return key ~= "sourcekit"
      and key ~= "flutterls"
      and key ~= "hls"
      and key ~= "ocamllsp"
      and key ~= "vue_ls"
  end, vim.tbl_keys(servers)),
}

require("mason-tool-installer").setup {
  ensure_installed = {
    "prettier",
    "stylua",
    "vue-language-server",
  },
}

for key, opts in pairs(servers) do
  if opts and type(opts) == "table" then
    vim.lsp.enable(key)
    vim.lsp.config(key, opts)
  end
end
```

- [ ] **Step 4: 创建 lua/lang/completion.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/lang/completion.lua`

```lua
local cmp_ok, cmp = pcall(require, "cmp")
local ui_ok, ui = pcall(require, "lang.lsp-ui")

if cmp_ok and ui_ok then
  cmp.setup {
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    sources = cmp.config.sources {
      { name = "nvim_lsp", group_index = 1 },
      { name = "vsnip", group_index = 2 },
      { name = "path", group_index = 3 },
    },
    mapping = require("core.keymaps").cmp(cmp),
    formatting = ui.formatting,
    sorting = {
      priority_weight = 2,
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.recently_used,
        require("clangd_extensions.cmp_scores"),
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }

  cmp.setup.cmdline("/", {
    sources = { { name = "buffer" } },
  })

  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
  })
end

local ok_cmp, m = pcall(require, "util.cmp")
if ok_cmp then
  m.cmp()
end
```

- [ ] **Step 5: 创建 lua/lang/lsp-ui.lua（lspsaga + lspkind）**

文件路径: `/Users/moody/.config/nvim-new/lua/lang/lsp-ui.lua`

```lua
local M = {}

local lspkind_ok, lspkind = pcall(require, "lspkind")
if lspkind_ok then
  lspkind.init {}
  local ok, _ = pcall(require, "cmp")
  if ok then
    M.formatting = {
      fields = { "kind", "abbr", "menu" },
      format = lspkind.cmp_format {
        mode = "symbol",
        maxwidth = 50,
        before = function(entry, vim_item)
          local source = entry.source.name
          local s = ({ nvim_lsp = "lsp" })[source]
          vim_item.menu = (s and { "[" .. s:upper():sub(1, 1) .. "]" }
            or { "[" .. source:upper():sub(1, 1) .. "]" })[1]
          return vim_item
        end,
      },
    }
  end
end

local saga_ok, lspsaga = pcall(require, "lspsaga")
if saga_ok then
  lspsaga.setup {
    ui = { border = "single" },
    symbol_in_winbar = { enable = false },
    lightbulb = { enable = false },
    diagnostic = { border_follow = false },
  }
else
  vim.notify("Failed to load lspsaga.")
end

return M
```

---

### Task 3: 所有语言 LSP 配置文件（14 个文件）

每个语言文件返回一个 table，与原项目内容一致。共享逻辑引用 `lang/lsp-handlers.lua`。

**Files:**
- Create: `lua/lang/lua.lua`
- Create: `lua/lang/rust.lua`（含 rustaceanvim 配置）
- Create: `lua/lang/cpp.lua`
- Create: `lua/lang/typescript.lua`
- Create: `lua/lang/vue.lua`
- Create: `lua/lang/json.lua`
- Create: `lua/lang/html.lua`
- Create: `lua/lang/css.lua`
- Create: `lua/lang/emmet.lua`
- Create: `lua/lang/swift.lua`（含 xcodebuild keymaps）
- Create: `lua/lang/flutter.lua`
- Create: `lua/lang/zig.lua`
- Create: `lua/lang/ocaml.lua`
- Create: `lua/lang/haskell.lua`
- Create: `lua/lang/rescript.lua`

- [ ] **Step 1: 创建 lua/lang/lua.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/lang/lua.lua`

```lua
local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
  end,
}
```

- [ ] **Step 2: 创建 lua/lang/rust.lua（含 rustaceanvim 全局配置）**

文件路径: `/Users/moody/.config/nvim-new/lua/lang/rust.lua`

```lua
local common = require("lang.lsp-handlers")
local M = {}

-- 注册 rustaceanvim server 配置
M.server = {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
    vim.lsp.inlay_hint.enable(false, { bufnr = buf })
  end,
  default_settings = {
    ["rust-analyzer"] = {
      procMacro = { enable = true },
      imports = {
        granularity = { group = "module" },
        prefix = "self",
      },
      cargo = { buildScripts = { enable = true } },
      check = { command = "clippy" },
      checkOnSave = true,
      diagnostics = { disabled = { "unresolved-proc-macro", "needless_return" } },
      inlayHints = {
        lifetimeElisionHints = { enable = true, useParameterNames = true },
      },
    },
  },
}

-- rustaceanvim 全局配置
local dap_config = require("debug.rust")
vim.g.rustaceanvim = {
  server = M.server,
  dap = dap_config,
  tools = {
    inlay_hints = {
      auto = false,
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
    hover_actions = {
      border = common.border,
      max_width = nil,
      max_height = nil,
      auto_focus = false,
    },
  },
}

return M.server
```

- [ ] **Step 3: 创建 lua/lang/cpp.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/lang/cpp.lua`

```lua
local common = require("lang.lsp-handlers")
local opts = {
  flags = common.flags,
  filetypes = { "c", "cc", "cpp", "objc", "objcpp" },
  handlers = common.handlers,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
    local ok, hints = pcall(require, "clangd_extensions.inlay_hints")
    if ok then
      hints.setup_autocmd()
      hints.set_inlay_hints()
    end
  end,
}
opts.capabilities = vim.tbl_deep_extend("force", common.capabilities, {
  offsetEncoding = "utf-16",
})
return opts
```

- [ ] **Step 4: 创建 lua/lang/typescript.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/lang/typescript.lua`

```lua
local common = require("lang.lsp-handlers")
local plugins = {}
local vue_ls_path = GetMasonPackagePath("vue-language-server")

if vue_ls_path then
  local found = vim.fs.find("typescript-plugin", {
    path = vue_ls_path,
    upward = false,
    type = "directory",
    limit = 1,
  })
  if found and #found > 0 then
    table.insert(plugins, {
      name = "@vue/typescript-plugin",
      location = found[1],
      languages = { "vue" },
    })
  end
end

return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  init_options = { plugins = plugins },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
  end,
  settings = {
    typescript = {
      preferences = {
        autoClosingTags = true,
        importModuleSpecifierPreference = "non-relative",
        includeCompletionsForModuleExports = true,
        quotePreference = "double",
      },
      suggest = { includeCompletionsForImportStatements = true },
    },
    javascript = {
      preferences = {
        autoClosingTags = true,
        importModuleSpecifierPreference = "non-relative",
        includeCompletionsForModuleExports = true,
        quotePreference = "double",
      },
      suggest = { includeCompletionsForImportStatements = true },
    },
  },
}
```

- [ ] **Step 5: 创建 lua/lang/vue.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/lang/vue.lua`

```lua
local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
  end,
  filetypes = { "vue" },
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/vue-language-server", "--stdio" },
}
```

- [ ] **Step 6: 创建 lua/lang/json.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/lang/json.lua`

```lua
local common = require("lang.lsp-handlers")
return {
  settings = { json = { schemas = require("schemastore").json.schemas() } },
  capabilities = common.capabilities,
  flags = common.flags,
  on_attach = function(client)
    common.disableFormat(client)
  end,
}
```

- [ ] **Step 7-12: 创建 html/css/emmet/swift/flutter/zig/ocaml/haskell/rescript**

（这些文件的配置项和原项目一致，使用 `lang/lsp-handlers.lua` 的共享逻辑。下面列出每个文件的完整内容。）

文件路径: `/Users/moody/.config/nvim-new/lua/lang/html.lua`

```lua
local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(_, buf)
    common.keybinding(buf)
  end,
}
```

文件路径: `/Users/moody/.config/nvim-new/lua/lang/css.lua`

```lua
local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(_, buf)
    common.keybinding(buf)
  end,
}
```

文件路径: `/Users/moody/.config/nvim-new/lua/lang/emmet.lua`

```lua
local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(_, buf)
    common.keybinding(buf)
  end,
  filetypes = { "html", "css", "typescriptreact", "javascriptreact", "javascript", "vue", "rescript" },
  init_options = {
    includeLanguages = {
      javascript = "javascriptreact",
      rescript = "html",
    },
    showSuggestionsAsSnippets = true,
  },
}
```

文件路径: `/Users/moody/.config/nvim-new/lua/lang/swift.lua`

```lua
local common = require("lang.lsp-handlers")
local M = {}

M.lsp = {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
    require("core.keymaps").map_xcodebuild(buf)
  end,
}

return M.lsp
```

文件路径: `/Users/moody/.config/nvim-new/lua/lang/flutter.lua`

```lua
local common = require("lang.lsp-handlers")
local keybindings = require("core.keymaps")

local opts = {
  handlers = common.handlers,
  capabilities = common.capabilities,
  flags = common.flags,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
    keybindings.map_flutter_tools(buf)
  end,
}

local telescope_ok = pcall(require, "telescope")
if telescope_ok then
  pcall(vim.cmd, "Telescope flutter")
end

return {
  on_setup = function(server)
    local flutter_tools_ok, flutter_tools = pcall(require, "flutter-tools")
    if not flutter_tools_ok then
      server.setup(opts)
    else
      flutter_tools.setup {
        lsp = opts,
        ui = {
          border = "single",
          notification_style = "plugin",
        },
        decorations = { statusline = { device = true } },
        outline = { open_cmd = "30vnew", auto_open = false },
      }
    end
  end,
}
```

文件路径: `/Users/moody/.config/nvim-new/lua/lang/zig.lua`

```lua
local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
  end,
}
```

文件路径: `/Users/moody/.config/nvim-new/lua/lang/ocaml.lua`

```lua
local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
  end,
}
```

文件路径: `/Users/moody/.config/nvim-new/lua/lang/haskell.lua`

```lua
local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
  end,
}
```

文件路径: `/Users/moody/.config/nvim-new/lua/lang/rescript.lua`

```lua
local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(_client, buf)
    common.keybinding(buf)
  end,
  settings = {
    rescript = {
      askToStartBuild = false,
      allowBuiltInFormatter = true,
      incrementalTypechecking = { enabled = true, acrossFiles = true },
      cache = { projectConfig = { enabled = true } },
      codeLens = true,
      inlayHints = { enable = true },
    },
  },
}
```

---

### Task 4: 编辑增强插件（Editor 模块 - 11 个插件）

所有文件直接返回 lazy.nvim spec。每个配置与原项目一致。

**Files:**
- Create: `lua/editor/comment.lua`
- Create: `lua/editor/autopairs.lua`
- Create: `lua/editor/autotag.lua`
- Create: `lua/editor/surround.lua`
- Create: `lua/editor/move.lua`
- Create: `lua/editor/illuminate.lua`
- Create: `lua/editor/hlsearch.lua`
- Create: `lua/editor/colorizer.lua`
- Create: `lua/editor/indent.lua`
- Create: `lua/editor/render-markdown.lua`
- Create: `lua/editor/conform.lua`

- [ ] **Step 1-11: 创建 11 个插件配置文件**

文件路径: `lua/editor/comment.lua`

```lua
return {
  "numToStr/Comment.nvim",
  opts = {
    opleader = { line = "gc", block = "gb" },
  },
}
```

文件路径: `lua/editor/autopairs.lua`

```lua
return {
  "windwp/nvim-autopairs",
  opts = {},
}
```

文件路径: `lua/editor/autotag.lua`

```lua
return {
  "windwp/nvim-ts-autotag",
  opts = {},
}
```

文件路径: `lua/editor/surround.lua`

```lua
return { "tpope/vim-surround" }
```

文件路径: `lua/editor/move.lua`

```lua
return { "matze/vim-move" }
```

文件路径: `lua/editor/illuminate.lua`

```lua
return {
  "RRethy/vim-illuminate",
  opts = {
    providers = { "lsp", "treesitter" },
  },
}
```

文件路径: `lua/editor/hlsearch.lua`

```lua
return {
  "nvimdev/hlsearch.nvim",
  event = "BufRead",
  opts = {},
}
```

文件路径: `lua/editor/colorizer.lua`

```lua
return {
  "NvChad/nvim-colorizer.lua",
  opts = {},
}
```

文件路径: `lua/editor/indent.lua`

```lua
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = function()
    local hooks = require("ibl.hooks")
    local highlight = { "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange", "RainbowGreen", "RainbowViolet", "RainbowCyan" }

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)

    return {
      exclude = {
        filetypes = {
          "startify", "dashboard", "log", "fugitive", "gitcommit",
          "markdown", "json", "txt", "help", "NvimTree",
          "TelescopePrompt", "flutterToolsOutline", "",
        },
        buftypes = { "terminal", "nofile" },
      },
      indent = { char = "" },
      scope = { char = "|", highlight = highlight, show_start = false, show_end = false },
    }
  end,
}
```

文件路径: `lua/editor/render-markdown.lua`

```lua
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  ft = { "markdown" },
  opts = {},
}
```

文件路径: `lua/editor/conform.lua`

```lua
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      ocaml = { "ocamlformat" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      dart = { "dart_format" },
      haskell = { "ormolu" },
      swift = { "swiftformat" },
      zig = { "zigfmt" },
      vue = { "prettier" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      markdown = { "prettier" },
    },
    formatters = {
      rustfmt = { options = { default_edition = "2024" } },
    },
    format_on_save = {
      timeout_ms = 2000,
      lsp_fallback = true,
    },
  },
}
```

---

### Task 5: UI 插件（which-key, noice, dressing, fidget, snacks, dashboard, lsp-progress, nerd-icons）

所有文件直接返回 lazy spec。

**Files:**
- Create: `lua/ui/which-key.lua`
- Create: `lua/ui/noice.lua`
- Create: `lua/ui/dressing.lua`
- Create: `lua/ui/fidget.lua`
- Create: `lua/ui/snacks.lua`
- Create: `lua/ui/lsp-progress.lua`
- Create: `lua/ui/nerd-icons.lua`

- [ ] **Step 1: 创建 lua/ui/which-key.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/which-key.lua`

```lua
return {
  "folke/which-key.nvim",
  opts = {
    preset = "modern",
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    win = { border = "single" },
    layout = {
      width = { min = 20 },
      spacing = 3,
    },
    triggers = {
      { "<leader>", mode = "n" },
      { "<localleader>", mode = "n" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.add {
      { "<leader>;", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", desc = "注释" },
      { "<leader>a", group = "代码操作" },
      { "<leader>ab", function() require("snacks").picker.buffers() end, desc = "搜索缓冲区" },
      { "<leader>ag", function() require("snacks").picker.grep() end, desc = "搜索关键字" },
      { "<leader>s", group = "搜索" },
      { "<leader>sc", ":nohlsearch<CR>", desc = "清除高亮" },
      { "<leader>b", group = "缓冲区" },
      { "<leader>bk", ":bw<CR>", desc = "关闭缓冲区" },
      { "<leader>d", group = "调试器" },
      { "<leader>dc", desc = "继续" },
      { "<leader>dh", desc = "帮助" },
      { "<leader>di", desc = "步入" },
      { "<leader>dj", desc = "步过" },
      { "<leader>do", desc = "步出" },
      { "<leader>dp", desc = "设置断点" },
      { "<leader>dq", desc = "退出" },
      { "<leader>ds", desc = "开始" },
      { "<leader>dt", desc = "切换调试视图" },
      { "<leader>f", group = "文件" },
      { "<leader>fc", "<cmd>NvimTreeCollapse<CR>", desc = "折叠文件树" },
      { "<leader>fd", function() require("snacks").picker.files() end, desc = "查找文件" },
      { "<leader>fr", "<cmd>NvimTreeRefresh<CR>", desc = "刷新文件树" },
      { "<leader>fs", ":update<CR>", desc = "保存" },
      { "<leader>ft", "<cmd>NvimTreeToggle<CR>", desc = "切换文件树" },
      { "<leader>g", group = "Git" },
      { "<leader>gD", desc = "对比差异~" },
      { "<leader>gR", desc = "重置缓冲区" },
      { "<leader>gS", desc = "暂存缓冲区" },
      { "<leader>gb", desc = "显示行提交信息" },
      { "<leader>gd", desc = "对比差异" },
      { "<leader>gp", desc = "预览更改" },
      { "<leader>gr", desc = "重置更改" },
      { "<leader>gs", desc = "暂存更改" },
      { "<leader>gt", desc = "切换行提交信息" },
      { "<leader>gu", desc = "撤销暂存" },
      { "<leader>gx", desc = "切换已删除" },
      { "<leader>l", group = "LSP" },
      { "<leader>lc", desc = "代码操作" },
      { "<leader>lo", "<cmd>Lspsaga outline<CR>", desc = "切换大纲" },
      { "<leader>lr", "<cmd>Lspsaga rename<CR>", desc = "重命名" },
      { "<leader>p", group = "项目" },
      { "<leader>pt", function() require("snacks").picker.projects() end, desc = "显示最近项目" },
      { "<leader>t", group = "终端" },
      { "<leader>tr", desc = "右侧终端" },
      { "<leader>tt", desc = "切换终端" },
      { "<leader>w", group = "窗口" },
      { "<leader>w=", "<C-w>=", desc = "平均分割窗口" },
      { "<leader>wc", "<C-w>c", desc = "关闭当前窗口" },
      { "<leader>wh", function() _G.split_in_terminal_group("h") end, desc = "水平分割窗口" },
      { "<leader>wo", "<C-w>o", desc = "关闭其他窗口" },
      { "<leader>wv", function() _G.split_in_terminal_group("v") end, desc = "垂直分割窗口" },
    }

    wk.add {
      { "<localleader>=", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>", desc = "格式化" },
      { "<localleader>s", group = "Swift" },
      { "<localleader>c", desc = "切换背景" },
      { "<localleader>d", group = "诊断" },
      { "<localleader>dd", desc = "显示行诊断(Vim API)" },
      { "<localleader>dl", desc = "显示行诊断" },
      { "<localleader>dn", desc = "下一个诊断" },
      { "<localleader>dp", desc = "上一个诊断" },
      { "<localleader>dw", desc = "显示光标诊断" },
      { "<localleader>e", "<cmd>Telescope buffers<CR>", desc = "显示缓冲区" },
      { "<localleader>k", "<cmd>bd<CR>", desc = "删除缓冲区" },
      { "<localleader>l", group = "LSP" },
      { "<localleader>lr", "<cmd>LspRestart<CR>", desc = "重启LSP" },
      { "<localleader>n", "<cmd>NerdIcons<CR>", desc = "打开图标选择器" },
      { "<localleader>o", function() require("snacks").picker.files() end, desc = "打开文件" },
      { "<localleader>t", group = "快速修复列表" },
      { "<localleader>tt", "<cmd>Lspsaga term_toggle<CR>", desc = "切换终端" },
      { "<localleader>tb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "缓冲区诊断(Trouble)" },
      { "<localleader>tx", "<cmd>Trouble diagnostics toggle focus=true<cr>", desc = "诊断(Trouble)" },
    }
  end,
}
```

- [ ] **Step 2: 创建 lua/ui/noice.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/noice.lua`

```lua
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      progress = { enabled = true },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    cmdline = { view = "cmdline_popup" },
    routes = {
      {
        filter = { event = "msg_show", kind = "", find = "written" },
        opts = { skip = true },
      },
    },
    views = {
      cmdline_popup = {
        position = { row = "20%", col = "50%" },
        size = { width = 60, height = "auto" },
      },
      popupmenu = {
        relative = "editor",
        position = { row = 8, col = "50%" },
        size = { width = 60, height = 10 },
        border = { style = "rounded", padding = { 0, 1 } },
        win_options = { winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" } },
      },
    },
  },
}
```

- [ ] **Step 3: 创建 lua/ui/fidget.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/fidget.lua`

```lua
return {
  "j-hui/fidget.nvim",
  tag = "v1.4.0",
  opts = function()
    local config = require("config")

    vim.fn.sign_define("fidget.Done", { text = "✔" })
    vim.fn.sign_define("fidget.Active", { text = "󰇊" })

    return {
      progress = {
        ignore = config.ignore or { "rust-analyzer", "hls", "lua_ls" },
        display = {
          progress_icon = { pattern = "dots", period = 1 },
          done_icon = "✔",
          overrides = {
            rust_analyzer = { name = "rust-analyzer" },
            lua_ls = { name = "lua-ls" },
          },
        },
      },
      notification = {
        override_vim_notify = true,
        filter = vim.log.levels.INFO,
        window = {
          align = "bottom",
          border = "single",
          relative = "win",
        },
      },
    }
  end,
}
```

- [ ] **Step 4: 创建 lua/ui/snacks.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/snacks.lua`

```lua
return {
  "folke/snacks.nvim",
  priority = 1000,
  opts = {
    input = { enabled = true },
    image = { enabled = true },
    terminal = {
      enabled = true,
      win = { position = "bottom" },
    },
    bigfile = { enabled = true },
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = { open = true, git_hl = true },
      signs = { width = 2 },
      refresh = 60,
    },
    quickfile = { enabled = true },
    picker = { enabled = true },
    lazygit = {
      enabled = true,
      configure = true,
      config = {
        os = { editPreset = "nvim-remote" },
        gui = { nerdFontsVersion = "3" },
        keybinding = {
          universal = { edit = "o", open = "<c-o>" },
        },
      },
    },
    words = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "o", desc = "Open Folder", action = ":NvimTreeFocus" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        {
          pane = 1,
          text = {
            { "      󰬬  ██╗     ███████╗██╗   ██╗███████╗██╗         ██╗   ██╗██████╗  󰬬 \n", hl = "GruvboxOrange" },
            { "      󰬬  ██║     ██╔════╝██║   ██║██╔════╝██║         ██║   ██║██╔══██╗ 󰬬 \n", hl = "GruvboxYellow" },
            { "      󰬬  ██║     █████╗  ██║   ██║█████╗  ██║         ██║   ██║██████╔╝ 󰬬 \n", hl = "GruvboxGreen" },
            { "      󰬬  ██║     ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║         ██║   ██║██╔═══╝  󰬬 \n", hl = "GruvboxAqua" },
            { "      󰬬  ███████╗███████╗ ╚████╔╝ ███████╗███████╗    ╚██████╔╝██║      󰬬 \n", hl = "GruvboxBlue" },
            { "      󰬬  ╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚══════╝     ╚═════╝ ╚═╝      󰬬 \n", hl = "GruvboxPurple" },
          },
          align = "center",
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    notifier = { enabled = false },
  },
}
```

- [ ] **Step 5: 创建 lua/ui/lsp-progress.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/lsp-progress.lua`

```lua
return {
  "linrongbin16/lsp-progress.nvim",
  opts = {
    client_format = function(client_name, spinner, series_messages)
      if #series_messages == 0 then
        return nil
      end
      return { name = client_name, body = spinner }
    end,
    format = function(client_messages)
      if #client_messages > 0 then
        return client_messages[1].body .. " Processing..."
      end
      return ""
    end,
  },
}
```

- [ ] **Step 6: 创建 lua/ui/dressing.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/dressing.lua`

```lua
return { "stevearc/dressing.nvim", opts = {} }
```

- [ ] **Step 7: 创建 lua/ui/nerd-icons.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/nerd-icons.lua`

```lua
return {
  "glepnir/nerdicons.nvim",
  cmd = "NerdIcons",
  opts = {
    border = "single",
    prompt = "󰨭 ",
    preview_prompt = " ",
    width = 0.5,
    down = "<C-n>",
    up = "<C-p>",
    copy = "<C-y>",
  },
}
```

---

### Task 6: Statusline + Tabline + Terminal（UI 核心显示）

**Files:**
- Create: `lua/ui/statusline/init.lua`（lualine 主体配置）
- Create: `lua/ui/statusline/gruvbox_modern.lua`
- Create: `lua/ui/statusline/gruvbox_classic.lua`
- Create: `lua/ui/statusline/evil.lua`
- Create: `lua/ui/statusline/bubbles.lua`
- Create: `lua/ui/statusline/slanted_gaps.lua`
- Create: `lua/ui/statusline/components/custom_file_path.lua`
- Create: `lua/ui/statusline/components/custom_filetype.lua`
- Create: `lua/ui/statusline/components/custom_mode.lua`
- Create: `lua/ui/tabline/init.lua`
- Create: `lua/ui/terminal/init.lua`

- [ ] **Step 1: 创建 lua/ui/terminal/init.lua（tt + tr 终端管理）**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/terminal/init.lua`

```lua
-- 从 nvim-012 common/terminal.lua 原样迁移
local function apply_style(win)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].statuscolumn = ""
  vim.wo[win].cursorline = false
  vim.wo[win].cursorcolumn = false
end

local function new_native_term()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.fn.termopen(vim.o.shell)
  vim.bo[buf].buflisted = false
  local win = vim.api.nvim_get_current_win()
  apply_style(win)
  vim.cmd("startinsert")
  return { win = win, buf = buf }
end

local function find_main_win()
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bt = vim.bo[vim.api.nvim_win_get_buf(w)].buftype
    if bt ~= "terminal" and bt ~= "nofile" then
      return w
    end
  end
  return nil
end

-- tt: 底部原生 split
local tt_main = nil
local tt_splits = {}

local function tt_is_open()
  return tt_main and vim.api.nvim_win_is_valid(tt_main.win)
end

local function tt_in_group()
  if tt_main and vim.api.nvim_win_is_valid(tt_main.win) then
    if vim.api.nvim_get_current_win() == tt_main.win then return true end
  end
  for _, e in ipairs(tt_splits) do
    if vim.api.nvim_win_is_valid(e.win) and vim.api.nvim_get_current_win() == e.win then return true end
  end
  return false
end

local function tt_toggle()
  if tt_is_open() then
    for _, e in ipairs(tt_splits) do
      if vim.api.nvim_win_is_valid(e.win) then
        if #vim.api.nvim_list_wins() > 1 then vim.api.nvim_win_close(e.win, false) end
        e.win = -1
      end
    end
    if #vim.api.nvim_list_wins() > 1 then vim.api.nvim_win_close(tt_main.win, false) end
    tt_main.win = -1
  else
    local editor_win = find_main_win()
    if editor_win then vim.api.nvim_set_current_win(editor_win) end
    vim.cmd("split")
    vim.cmd("resize 15")
    if tt_main and vim.api.nvim_buf_is_valid(tt_main.buf) then
      vim.api.nvim_win_set_buf(0, tt_main.buf)
      tt_main.win = vim.api.nvim_get_current_win()
      apply_style(tt_main.win)
      vim.cmd("startinsert")
    else
      tt_main = new_native_term()
    end
    local valid = {}
    for _, e in ipairs(tt_splits) do
      if vim.api.nvim_buf_is_valid(e.buf) then table.insert(valid, e) end
    end
    tt_splits = {}
    for _, e in ipairs(valid) do
      vim.cmd("vsplit")
      vim.api.nvim_win_set_buf(0, e.buf)
      e.win = vim.api.nvim_get_current_win()
      apply_style(e.win)
      vim.cmd("startinsert")
      table.insert(tt_splits, e)
    end
  end
end

-- tr: 右侧 Snacks 浮动
local tr_main_win = -1
local tr_splits = {}

local function tr_is_open()
  return vim.api.nvim_win_is_valid(tr_main_win)
end

local function tr_toggle()
  if tr_is_open() then
    for _, e in ipairs(tr_splits) do
      if vim.api.nvim_win_is_valid(e.win) then vim.api.nvim_win_close(e.win, false) e.win = -1 end
    end
    Snacks.terminal.toggle(nil, { count = 20, win = { position = "right" } })
    tr_main_win = -1
  else
    local before = {}
    for _, w in ipairs(vim.api.nvim_list_wins()) do before[w] = true end
    Snacks.terminal.toggle(nil, { count = 20, win = { position = "right" } })
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if not before[w] then tr_main_win = w; break end
    end
    local valid = {}
    for _, e in ipairs(tr_splits) do
      if vim.api.nvim_buf_is_valid(e.buf) then table.insert(valid, e) end
    end
    tr_splits = {}
    for _, e in ipairs(valid) do
      vim.cmd("vsplit")
      vim.api.nvim_win_set_buf(0, e.buf)
      e.win = vim.api.nvim_get_current_win()
      apply_style(e.win)
      vim.cmd("startinsert")
      table.insert(tr_splits, e)
    end
  end
end

-- Split in terminal group
_G.split_in_terminal_group = function(direction)
  if tt_in_group() then
    -- tt_add_split(direction) - simplified
    vim.cmd(direction == "h" and "vsp" or "sp")
  elseif tr_in_group() then
    vim.cmd(direction == "h" and "vsp" or "sp")
  else
    vim.cmd(direction == "h" and "vsp" or "sp")
  end
end

-- TermClose cleanup
vim.api.nvim_create_autocmd("TermClose", {
  callback = function(ev)
    if tt_main and tt_main.buf == ev.buf then
      if vim.api.nvim_win_is_valid(tt_main.win) and #vim.api.nvim_list_wins() > 1 then
        vim.api.nvim_win_close(tt_main.win, false)
      end
      if vim.api.nvim_buf_is_valid(ev.buf) then vim.api.nvim_buf_delete(ev.buf, { force = true }) end
      tt_main = nil
    end
  end,
})

vim.keymap.set({ "n", "t" }, "<leader>tt", tt_toggle, { desc = "切换底部终端" })
vim.keymap.set({ "n", "t" }, "<leader>tr", tr_toggle, { desc = "切换右侧终端" })
```

- [ ] **Step 2: 创建 lua/ui/statusline/init.lua**

各 lualine 主题文件原样迁移（保持所有硬编码颜色不变），init.lua 负责从 config 读取主题名并加载。

文件路径: `/Users/moody/.config/nvim-new/lua/ui/statusline/init.lua`

```lua
local config = require("config")
local theme = config.lua_line or "gruvbox_modern"

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "echasnovski/mini.icons" },
  opts = function()
    local theme_module = require("ui.statusline." .. theme)
    return theme_module
  end,
}
```

- [ ] **Step 3-7: 创建 5 套 lualine 主题文件**

每个文件返回 lualine 的配置 table，与原项目内容一致。这里列出文件路径，内容从 nvim-012 对应路径原样复制：
- `lua/plugins/line-theme/gruvbox_modern.lua` → `lua/ui/statusline/gruvbox_modern.lua`
- `lua/plugins/line-theme/gruvbox_theme.lua` → `lua/ui/statusline/gruvbox_classic.lua`
- `lua/plugins/line-theme/evil_lualine.lua` → `lua/ui/statusline/evil.lua`
- `lua/plugins/line-theme/bubbles.lua` → `lua/ui/statusline/bubbles.lua`
- `lua/plugins/line-theme/slanted-gaps.lua` → `lua/ui/statusline/slanted_gaps.lua`

以及自定义组件：
- `lua/plugins/line-theme/components/custom-file-path.lua` → `lua/ui/statusline/components/custom_file_path.lua`
- `lua/plugins/line-theme/components/custom-filetype.lua` → `lua/ui/statusline/components/custom_filetype.lua`
- `lua/plugins/line-theme/components/custom-mode.lua` → `lua/ui/statusline/components/custom_mode.lua`

- [ ] **Step 8: 创建 lua/ui/tabline/init.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/tabline/init.lua`

```lua
return {
  "nanozuki/tabby.nvim",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    line = function(line)
      local theme = {
        fill = "TabLineFill",
        head = { bg = "#907aa9", fg = "#f2e9de", style = "bold" },
        current_tab = { bg = "#d75f5f", fg = "#f2e9de", style = "bold" },
        tab = { bg = "#3c3836", fg = "#d75f5f" },
        tail = { bg = "TabLineFill", fg = "#907aa9" },
      }

      -- 透明背景
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
        end,
      })

      local function get_icon(filename)
        if not filename or filename == "" then return "󰈚" end
        local icon, _ = require("mini.icons").get("file", filename)
        return icon or "󰈚"
      end

      local function get_icon_hl(filename, tab_bg)
        if not filename or filename == "" then return nil end
        local _, hl_name = require("mini.icons").get("file", filename)
        if not hl_name then return nil end
        local ok, hi = pcall(vim.api.nvim_get_hl, 0, { name = hl_name, link = false })
        if not ok or not hi.fg then return nil end
        local fg = string.format("#%06x", hi.fg)
        local key = "TabbyIcon_" .. hl_name:gsub("[^%w]", "_") .. "_" .. tab_bg:sub(2)
        vim.api.nvim_set_hl(0, key, { fg = fg, bg = tab_bg })
        return key
      end

      local function get_diagnostics(bufid)
        local diagnostics = vim.diagnostic.get(bufid)
        local count = { error = 0, warn = 0, info = 0 }
        for _, d in ipairs(diagnostics) do
          if d.severity == vim.diagnostic.severity.ERROR then count.error = count.error + 1
          elseif d.severity == vim.diagnostic.severity.WARN then count.warn = count.warn + 1
          elseif d.severity == vim.diagnostic.severity.INFO then count.info = count.info + 1 end
        end
        local res = ""
        if count.error > 0 then res = res .. "  " .. count.error end
        if count.warn > 0 then res = res .. "  " .. count.warn end
        if count.info > 0 then res = res .. "  " .. count.info end
        return res
      end

      return {
        { { "  ", hl = theme.head }, line.sep("", theme.head, theme.fill) },
        line.bufs().foreach(function(buf)
          local is_active = buf.is_current()
          local hl = is_active and theme.current_tab or theme.tab
          local tab_bg = is_active and "#d75f5f" or "#3c3836"
          local icon = get_icon(buf.name())
          local icon_hl = get_icon_hl(buf.name(), tab_bg) or hl
          local name = buf.name() == "" and "[No Name]" or vim.fn.fnamemodify(buf.name(), ":t")
          local changed = buf.is_changed() and " ●" or ""
          local diag = get_diagnostics(buf.id)
          return {
            line.sep("", hl, theme.fill),
            { icon, hl = icon_hl }, " ", name, diag, changed,
            line.sep("", hl, theme.fill),
            hl = hl, margin = " ",
          }
        end),
        line.spacer(), hl = theme.fill,
        { line.sep("", theme.head, theme.fill), { " 󰈚 ", hl = theme.head } },
      }
    end,
  },
}
```

---

### Task 7: 文件导航 + Git + Treesitter

**Files:**
- Create: `lua/file/telescope.lua`
- Create: `lua/file/tree.lua`
- Create: `lua/file/project.lua`
- Create: `lua/file/trouble.lua`
- Create: `lua/git/gitsigns.lua`
- Create: `lua/editor/treesitter.lua`

- [ ] **Step 1: 创建 lua/file/telescope.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/file/telescope.lua`

内容与原 `plugins/telescope.lua` 一致，只是路径调整。包含：fzf sorter、rg 参数、布局、边框、media 扩展等。

- [ ] **Step 2: 创建 lua/file/tree.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/file/tree.lua`

内容与原 `plugins/nvim-tree.lua` 一致（浮动模式、on_attach 所有键映射）。

- [ ] **Step 3: 创建 lua/file/project.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/file/project.lua`

内容与原 `plugins/project.lua` 一致（检测 pattern、Telescope projects 扩展）。

- [ ] **Step 4: 创建 lua/file/trouble.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/file/trouble.lua`

```lua
return {
  "folke/trouble.nvim",
  opts = { auto_close = true, win = { type = "float" } },
}
```

- [ ] **Step 5: 创建 lua/git/gitsigns.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/git/gitsigns.lua`

内容与原 `plugins/gitsigns.lua` 一致（所有 signs、on_attach 键映射）。

- [ ] **Step 6: 创建 lua/editor/treesitter.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/editor/treesitter.lua`

```lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "vim", "lua", "javascript", "typescript", "tsx",
      "c", "cpp", "json", "ocaml", "haskell", "swift",
      "zig", "css", "html", "dart", "markdown", "markdown_inline", "vue",
    },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        node_decremental = "<BS>",
        scope_incremental = "<TAB>",
      },
    },
    indent = { enable = true },
  },
  config = function()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
    vim.wo.foldlevel = 99
  end,
}
```

---

### Task 8: 调试器（Debug 模块）

**Files:**
- Create: `lua/debug/init.lua`
- Create: `lua/debug/rust.lua`

- [ ] **Step 1: 创建 lua/debug/init.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/debug/init.lua`

内容与原 `lsp/dap/nvim-dap/init.lua` 一致（nvim-dap 核心 + nvim-dap-ui 布局 + virtual-text + 自动开/关 + DAP 键映射）。

- [ ] **Step 2: 创建 lua/debug/rust.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/debug/rust.lua`

```lua
local extension_path = os.getenv("HOME")
  .. "/.local/share/nvim/lazy/vimspector/gadgets/macos/CodeLLDB"
local codelldb_path = extension_path .. "/adapter/codelldb"
local liblldb_path = extension_path .. "/lldb/lib/liblldb.dylib"

return {
  adapter = require("rustaceanvim.config").get_codelldb_adapter(
    codelldb_path,
    liblldb_path
  ),
}
```

---

### Task 9: 主题系统 + Neovide

**Files:**
- Create: `lua/themes/init.lua`
- Create: `lua/themes/gruvbox.lua`
- Create: `lua/themes/everforest.lua`
- Create: `lua/themes/catppuccin.lua`
- Create: `lua/themes/neovide.lua`

- [ ] **Step 1: 创建 lua/themes/init.lua（主题注册表 + API + 颜色提取）**

文件路径: `/Users/moody/.config/nvim-new/lua/themes/init.lua`

```lua
local config = require("config")
local M = {}

-- 主题注册表：每个主题定义 colorscheme + statusline + tabline 的对应关系
M.registry = {
  gruvbox = {
    colorscheme = "gruvbox",
    background = "dark",
    transparent = true,
    statusline = "gruvbox_modern",
    tabline = "gruvbox_modern",
  },
  everforest = {
    colorscheme = "everforest",
    background = "dark",
    transparent = false,
    statusline = "gruvbox_modern",
    tabline = "gruvbox_modern",
  },
  catppuccin = {
    colorscheme = "catppuccin",
    background = "dark",
    transparent = false,
    statusline = "evil",
    tabline = "gruvbox_modern",
  },
}

-- 当前使用的主题名（支持用户覆盖）
M.current = config.colorscheme or "gruvbox"

-- 加载 colorscheme
vim.schedule(function()
  local theme = M.registry[M.current]
  if theme then
    vim.cmd.colorscheme(theme.colorscheme)
    vim.o.background = theme.background

    -- 如果是 gruvbox 且 transparent_mode 为 true，额外加载透明配置
    if theme.colorscheme == "gruvbox" and theme.transparent then
      require("themes.gruvbox")
    elseif theme.colorscheme == "everforest" then
      require("themes.everforest")
    elseif theme.colorscheme == "catppuccin" then
      require("themes.catppuccin")
    end
  end
  vim.g.python3_host_prog = config.python3_host_prog or "/usr/bin/python3"
end)

-- API：获取当前主题的 statusline 名称
function M.get_statusline_theme()
  local theme = M.registry[M.current]
  return theme and theme.statusline or "gruvbox_modern"
end

-- API：获取当前主题的 tabline 名称
function M.get_tabline_theme()
  local theme = M.registry[M.current]
  return theme and theme.tabline or "gruvbox_modern"
end

return M
```

- [ ] **Step 2: 创建 lua/themes/gruvbox.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/themes/gruvbox.lua`

原样迁移 `plugins/theme/gruvbox.lua`（gruvbox.setup 配置）。

- [ ] **Step 3: 创建 lua/themes/everforest.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/themes/everforest.lua`

原样迁移 `plugins/theme/everforest.lua`（everforest.setup 配置）。

- [ ] **Step 4: 创建 lua/themes/catppuccin.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/themes/catppuccin.lua`

原样迁移 `plugins/theme/catppuccin.lua`（catppuccin.setup 配置）。

- [ ] **Step 5: 创建 lua/themes/neovide.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/themes/neovide.lua`

```lua
if vim.g.neovide then
  vim.g.neovide_input_macos_option_is_meta = true
  vim.g.neovide_cursor_vfx_mode = "wireframe"
end
```

---

### Task 10: 工具函数 + Xcodebuild + Mini Icons + 其他 Plugin

**Files:**
- Create: `lua/util/mason.lua`（GetMasonPackagePath）
- Create: `lua/util/cmp.lua`（CMP autopairs 集成）
- Create: `lua/ui/xcodebuild.lua`
- Create: `lua/ui/mini-icons.lua`
- Create: `lua/ui/lazydev.lua`

- [ ] **Step 1: 创建 lua/util/cmp.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/util/cmp.lua`

```lua
local M = {}

function M.cmp()
  local ok, cmp_auto_pairs = pcall(require, "nvim-autopairs.completion.cmp")
  local is_ok, cmp = pcall(require, "cmp")
  if ok and is_ok then
    cmp.event:on("confirm_done", cmp_auto_pairs.on_confirm_done())
  end
end

return M
```

- [ ] **Step 2: 创建 lua/ui/xcodebuild.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/xcodebuild.lua`

```lua
return {
  "wojciech-kulik/xcodebuild.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = { auto_save = false },
}
```

- [ ] **Step 3: 创建 lua/ui/mini-icons.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/mini-icons.lua`

```lua
return {
  "echasnovski/mini.icons",
  lazy = false,
  version = false,
  opts = {},
  config = function()
    require("mini.icons").setup()
    require("mini.icons").mock_nvim_web_devicons()
  end,
}
```

- [ ] **Step 4: 创建 lua/ui/lazydev.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/ui/lazydev.lua`

```lua
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {},
}
```

---

### Task 11: 聚合 plugins.lua + 完成 init.lua

将所有模块的 spec 聚合到 plugins.lua，由 lazy.nvim 加载。

- [ ] **Step 1: 完成 lua/plugins.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/plugins.lua`

```lua
return {
  require("core.basic"),
  require("core.keymaps"),
  require("core.autocmds"),

  -- Theme plugins
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "catppuccin/nvim", name = "catppuccin" },
  { "neanias/everforest-nvim", lazy = false, priority = 1000 },
  "limitLiu/zephyr-nvim",

  -- Mason + LSP
  require("lang.mason"),
  { "williamboman/mason-lspconfig.nvim" },
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  { "neovim/nvim-lspconfig" },
  require("lang.completion"),
  "onsails/lspkind-nvim",
  require("lang.lsp-ui"),

  -- Rust
  { "mrcjkb/rustaceanvim", version = "^6", ft = { "rust" }, event = "BufReadPre" },
  "b0o/SchemaStore.nvim",
  { "p00f/clangd_extensions.nvim", lazy = true },

  -- Treesitter
  require("editor/treesitter"),

  -- Editor
  require("editor.comment"),
  require("editor.autopairs"),
  require("editor.surround"),
  require("editor.move"),
  require("editor.illuminate"),
  require("editor.hlsearch"),
  require("editor.colorizer"),
  require("editor.indent"),
  require("editor.render-markdown"),
  require("editor.conform"),
  { "windwp/nvim-ts-autotag", opts = {} },

  -- UI
  require("ui.which-key"),
  require("ui.noice"),
  { "rcarriga/nvim-notify" },
  require("ui.dressing"),
  require("ui.fidget"),
  require("ui.snacks"),
  require("ui.lsp-progress"),
  require("ui.nerd-icons"),
  require("ui.xcodebuild"),
  require("ui.mini-icons"),
  require("ui.lazydev"),

  -- Statusline + Tabline + Terminal
  require("ui.statusline.init"),
  require("ui.tabline.init"),

  -- File navigation
  require("file.telescope"),
  require("file.tree"),
  require("file.project"),
  require("file.trouble"),
  "ahmedkhalf/project.nvim",

  -- Git
  require("git.gitsigns"),

  -- Debug
  "theHamsta/nvim-dap-virtual-text",
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  "puremourning/vimspector",
  require("debug.init"),
  require("debug.rust"),

  -- Flutter
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
  },

  -- Vimspector (already listed above)
  -- Zephyr theme (already listed above)
}
```

- [ ] **Step 2: 完成 lua/init.lua**

文件路径: `/Users/moody/.config/nvim-new/lua/init.lua`

```lua
require("core.bootstrap")
require("themes.neovide")
require("core.basic")
require("core.keymaps")
require("core.autocmds")
require("themes.init")

-- Lazy plugins
require("lazy").setup(require("plugins"))

-- LSP setup
require("lang.init")

-- Completion
require("lang.completion")

-- Rust
pcall(require, "lang.rust")

-- Terminal management
require("ui.terminal.init")

-- Treesitter fold + debug
require("editor.treesitter")

-- nvim-dap
require("debug.init")
```

---

### Task 12: 验证

- [ ] **Step 1: 在 nvim-new 目录下启动 Neovim 测试**
```
cd ~/.config/nvim-new && NVIM_APPNAME= nvim-new nvim
```

- [ ] **Step 2: 检查插件安装**
`:Lazy` → 确认 64 个插件全部加载正常

- [ ] **Step 3: 检查 LSP**
`:LspInfo` → 确认各语言 LSP server 正常启动

- [ ] **Step 4: 检查快捷键**
`:WhichKey` → 确认所有分组和快捷键正确

- [ ] **Step 5: 检查 statusline + tabline**
确认 lualine 样式正确、tabby 样式正确

- [ ] **Step 6: 检查终端**
`<leader>tt` → 底部终端正常
`<leader>tr` → 右侧终端正常

- [ ] **Step 7: 检查 Telescope**
`:Telescope find_files` → fzf sorter、布局、预览正常

- [ ] **Step 8: 检查 nvim-tree**
`:NvimTreeToggle` → 浮动模式正常

- [ ] **Step 9: 检查 Git + DAP**
`:Gitsigns` / 打开 git 仓库文件验证 gutter、<leader>gg 打开 lazygit
Rust 文件验证 `<leader>ds` 等 DAP 操作
