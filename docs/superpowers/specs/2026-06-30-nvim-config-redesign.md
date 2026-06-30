# Neovim 配置重构设计文档

## 概述

将 `nvim-012` 的完整 Neovim 配置迁移到 `nvim-new`，保持 **100% 功能** 不变的前提下重新组织目录结构，提高可维护性和可扩展性。

## 目录结构

```
lua/
├── init.lua                    # 入口：bootstrap → core → lang → themes → ui
├── config.lua                  # 唯一用户配置入口
├── plugins.lua                 # 聚合全部 64 个插件 spec
│
├── core/
│   ├── bootstrap.lua           # lazy.nvim 自举安装（稳定分支）
│   ├── basic.lua               # vim 选项（缩进、搜索、编码等）
│   ├── keymaps.lua             # 全局快捷键（leader、窗口等）
│   └── autocmds.lua            # 自动命令
│
├── ui/
│   ├── which-key.lua           # which-key 分组注册 + 配置
│   ├── noice.lua               # cmdline/messages 替换
│   ├── dressing.lua            # vim.ui 增强
│   ├── snacks.lua              # statuscolumn, bigfile, quickfile, words
│   ├── dashboard.lua           # Snacks dashboard 启动页
│   ├── fidget.lua              # LSP 进度提示
│   ├── statusline/
│   │   ├── init.lua            # Lualine 配置（颜色从 themes 注入）
│   │   ├── gruvbox_modern.lua  # 原样迁移（已含手动适配颜色）
│   │   ├── gruvbox_classic.lua # 原样迁移
│   │   ├── evil.lua            # 原样迁移
│   │   ├── bubbles.lua         # 原样迁移
│   │   ├── slanted-gaps.lua    # 原样迁移
│   │   └── components/         # 自定义组件（file-path, filetype, mode）
│   ├── tabline/
│   │   └── init.lua            # Tabby 配置（颜色从 themes 注入）
│   └── terminal/
│       └── init.lua            # tt（底部）/ tr（浮动）终端管理
│
├── editor/
│   ├── comment.lua             # gc/gb 注释
│   ├── autopairs.lua           # 自动闭合括号
│   ├── autotag.lua             # HTML/JSX 自动闭合标签
│   ├── surround.lua            # ys/cs/ds
│   ├── move.lua                # 行移动
│   ├── illuminate.lua          # 光标词高亮
│   ├── hlsearch.lua            # 搜索高亮增强
│   ├── colorizer.lua           # 颜色代码高亮
│   ├── indent.lua              # 彩虹缩进指引线
│   ├── render-markdown.lua     # Markdown 实时渲染
│   └── conform.lua             # 格式化（formatter_by_ft）
│
├── file/
│   ├── telescope.lua           # Telescope（fzf, ripgrep, 布局）
│   ├── tree.lua                # nvim-tree（浮动模式）
│   ├── project.lua             # project.nvim
│   └── trouble.lua             # 诊断/快速修复
│
├── git/
│   ├── gitsigns.lua            # git signs + git 键映射
│   └── lazygit.lua             # snacks.lazygit 集成
│
├── lang/
│   ├── init.lua                # Mason 初始化 + 公共 LSP 设置
│   ├── mason.lua               # Mason 自动安装列表
│   ├── lsp-handlers.lua        # 共享 on_attach / capabilities / border
│   ├── completion.lua          # nvim-cmp 配置
│   ├── lua.lua                 # Lua / lua_ls
│   ├── rust.lua                # Rust / rust-analyzer
│   ├── cpp.lua                 # C/C++ObjC / clangd + clangd_extensions
│   ├── typescript.lua          # TS/JS/TSX/JSX/Vue / ts_ls
│   ├── vue.lua                 # Vue / vue_ls（Volar）
│   ├── json.lua                # JSON / jsonls + SchemaStore
│   ├── html.lua                # HTML / html_ls
│   ├── css.lua                 # CSS/SCSS / cssls
│   ├── emmet.lua               # Emmet / emmet_language_server
│   ├── swift.lua               # Swift / sourcekit + xcodebuild
│   ├── flutter.lua             # Dart/Flutter / flutter-tools
│   ├── zig.lua                 # Zig / zls
│   ├── ocaml.lua               # OCaml / ocamllsp
│   ├── haskell.lua             # Haskell / hls
│   └── rescript.lua            # ReScript / rescriptls
│
├── debug/
│   ├── init.lua                # nvim-dap + nvim-dap-ui + 自动开/关
│   ├── virtual-text.lua        # DAP 内联显示
│   └── rust.lua                # Rust CodeLLDB adapter
│
├── themes/
│   ├── init.lua                # 主题注册表 + API + 切换快捷键
│   ├── adapter.lua             # 从 colorscheme 高亮组自动提取颜色
│   ├── gruvbox.lua             # colorscheme 配置 + 手配 UI 颜色
│   ├── everforest.lua          # colorscheme 配置（UI 颜色自动提取）
│   └── catppuccin.lua          # colorscheme 配置（UI 颜色自动提取）
│
└── util/
    ├── mason.lua               # GetMasonPackagePath
    └── cmp.lua                 # CMP autopairs 集成
```

## 核心架构设计

### 插件加载机制

每个配置文件直接返回 lazy.nvim 的 plugin spec，由 `plugins.lua` 聚合返回：

```lua
-- plugins.lua
return {
  require("core.basic"),
  require("ui.noice"),
  require("editor.comment"),
  require("lang.typescript"),
  -- ... 全部插件
}
```

每个插件的配置自包含，增删一个插件只需操作一个文件。

### 主题系统（核心设计）

`themes/init.lua` 维护主题注册表。**statusline 样式 + tabline 样式在一个注册表中统一配置**，用户只需在 `config.lua` 里指定一个 `M.ui_theme`：

```lua
-- config.lua（用户唯一配置入口）
M.ui_theme = "gruvbox"       -- 只改这一个，statusline+tabline 全部跟着换

-- ★ 可选：覆盖任意颜色（最高优先级）
M.custom_colors = {
  statusline = {
    normal = { a = { bg = "#1d2021" } },
  },
}
```

主题注册表（在 `themes/init.lua` 中，一个文件管理全部）：

```lua
-- themes/init.lua
M.registry = {
  gruvbox = {
    colorscheme = "gruvbox",
    background = "dark",
    transparent = true,
    statusline = "gruvbox_modern",     -- 对应 5 套中的一套
    tabline = "gruvbox_modern",        -- 对应 2 套中的一套
    statusline_colors = nil,           -- 可选覆盖
  },
  everforest = {
    colorscheme = "everforest",
    background = "dark",
    transparent = false,
    statusline = "gruvbox_modern",     -- 可以复用已配好的 lualine
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
```

#### 颜色覆盖三层次

```
lualine 主题默认颜色（主题文件内的硬编码）
        ↓
主题注册表覆盖（themes/init.lua 中 statusline_colors）
        ↓
用户自定义覆盖（config.lua 中 custom_colors） ← 最高优先级
```

lualine 主题文件改为函数，接收可选覆盖参数：

```lua
-- ui/statusline/gruvbox_modern.lua
return function(overrides)
  local colors = {
    normal = { a = { bg = "#1d2021", fg = "#ebdbb2" } },
    insert = { a = { bg = "#b8bb26", fg = "#1d2021" } },
    visual = { a = { bg = "#fe8019", fg = "#1d2021" } },
  }
  return vim.tbl_deep_extend("force", colors, overrides or {})
end
```

#### 自动颜色提取

`themes/adapter.lua` 从 colorscheme 高亮组（StatusLine, Normal, Function, Constant, DiagnosticError 等）自动提取颜色。当主题注册表中 statusline/tabline 的 `_colors` 为 nil 且 lualine 主题文件不存在时，作为 fallback 保证新 colorscheme 至少能看。

### Language 模块设计

每个语言文件自包含，声明自己服务的 filetypes。`typescript.lua` 包含 vue 相关的 ts 配置，`vue.lua` 独立管理 volar。共享逻辑（on_attach、capabilities、border 样式）集中在 `lsp-handlers.lua` 中。

### LSP 键映射

- 全局键映射（leader、窗口跳转等）→ `core/keymaps.lua`
- LSP 键映射（K/gd/gr 等）→ `lang/lsp-handlers.lua`
- Gitsigns 键映射（]c/[c 等）→ `git/gitsigns.lua`
- DAP 键映射 → `debug/init.lua` 和 `debug/rust.lua`

## 保留功能清单（100% 不落地任何一个）

- [x] 64 个插件（通过 lazy.nvim 管理）
- [x] lazy.nvim 自举安装
- [x] init.lua 入口
- [x] 全局快捷键（leader=Space, localleader=,, kj/jk/kk/jj 等）
- [x] 窗口跳转（C-h/j/k/l）+ 窗口尺寸调整（A-[ / A-] / A-h / A-l）
- [x] Buffer 切换（Tab / S-Tab）
- [x] 滚动加速（C-u=9k, C-d=9j）
- [x] Colorscheme 切换（<localleader>c）
- [x] Lazygit（<leader>gg）
- [x] Markdown 切换（<leader>mt）
- [x] Neovide 粘贴（D-v）
- [x] LSP 键映射（K/gd/gr/gn/gp + localleader dw/dl/dd + leader lc）
- [x] CMP 键映射（A-. 补全, CR/Tab 确认, C-p/C-n 选择）
- [x] DAP 键映射（ds/dq/dc/dp/dj/do/di/dh/dt 等）
- [x] Xcodebuild 键映射（localleader ss/sr）
- [x] Flutter 键映射（leader ac）
- [x] Gitsigns 键映射（]c/[c, leader gs/gr/gS/gu/gR/gp/gb/gt/gd/gx）
- [x] Telescope 键映射（C-u/d/n/p）
- [x] Comment 键映射（gc/gb）
- [x] nvim-tree 内置键映射
- [x] 终端管理（<leader>tt 底部, <leader>tr 浮动）
- [x] 自动命令（TextYankPost 高亮, WinLeave 退出终端）
- [x] 14 个 LSP 服务器（lua_ls, clangd, ts_ls, vue_ls, jsonls, html, cssls, emmet, sourcekit, zls, ocamllsp, hls, rust-analyzer, flutter）
- [x] 3 套 colorscheme（gruvbox, catppuccin, everforest）
- [x] 5 套 lualine 主题（gruvbox_modern, gruvbox_classic, evil, bubbles, slanted-gaps）
- [x] 2 套 tabby 主题
- [x] 21 个 treesitter parsers
- [x] 12 种语言 formatter（conform.nvim 自动保存）
- [x] nvim-cmp 补全（LSP + buffer + path + vsnip + friendly-snippets）
- [x] DAP（Rust CodeLLDB + nvim-dap-ui + virtual-text）
- [x] Snacks（dashboard/lazygit/statuscolumn/bigfile/picker/words）
- [x] Noice + nvim-notify 消息系统
- [x] Telescope（fzf sorter, ripgrep, 自定义布局/边框）
- [x] nvim-tree 浮动模式
- [x] Which-key 全部分组注册
- [x] 彩虹缩进指引线（indent-blankline）
- [x] 高亮组（vim-illuminate, hlsearch.nvim, colorizer.lua）
- [x] Markdown 实时渲染
- [x] 编辑增强（autopairs, autotag, surround, move, comment）
- [x] 浮动 Trouble 诊断
- [x] LSP 进度指示（fidget + lsp-progress）
- [x] Mason 自动安装 + 排除列表
- [x] Neovide 配置（option-as-meta, wireframe cursor）
- [x] 自定义 statusline 组件（file-path, filetype, mode）
- [x] lspsaga（hover, definition, code_action, diagnostics UI）
- [x] lspkind（补全菜单图标）
