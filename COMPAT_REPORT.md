# Neovim 0.12.0 兼容性报告

生成日期：2026-04-06

## 已修复

### 1. nvim-treesitter API 改名
- **文件**：`lua/plugins/nvim-treesitter.lua:1`
- **原因**：nvim-treesitter 将 `configs.lua` 重命名为 `config.lua`
- **修复**：`require("nvim-treesitter.configs")` → `require("nvim-treesitter.config")`

### 2. nvim-treesitter-rescript 插件不兼容
- **文件**：`lua/common/plugins.lua`、`lua/lsp/setup.lua`
- **原因**：`limitLiu/nvim-treesitter-rescript` 使用 `.vim` 插件文件，0.12 不兼容
- **修复**：注释掉插件声明和 `rescriptls` LSP 配置

---

## 待修复

### 3. DAP 使用废弃的高亮组（主配置也需要改）
- **文件**：`lua/lsp/dap/nvim-dap/init.lua`
- **问题**：`LspDiagnosticsSign*` 高亮组在 0.12 已移除
- **修复方案**：
  ```lua
  -- 改前
  vim.fn.sign_define("DapBreakpoint", { texthl = "LspDiagnosticsSignError" })
  vim.fn.sign_define("DapStopped", { texthl = "LspDiagnosticsSignInformation" })
  vim.fn.sign_define("DapBreakpointRejected", { texthl = "LspDiagnosticsSignHint" })
  -- 改后
  vim.fn.sign_define("DapBreakpoint", { texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DapStopped", { texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DapBreakpointRejected", { texthl = "DiagnosticSignHint" })
  ```

### 4. vim.lsp health.lua:202 ERROR（等插件更新）
- **来源**：nvim-lspconfig 内部 health checker
- **原因**：0.12 改变了 LSP 内部数据结构，`table.concat` 调用报错
- **处理**：等待 nvim-lspconfig 更新，无需手动修改

### 5. vim.highlight deprecated（等插件更新）
- **来源**：rustaceanvim 内部
- **原因**：`vim.highlight` 在 0.12 已废弃，应使用 `vim.hl`
- **处理**：等待 rustaceanvim 更新

### 6. vim.validate deprecated（等插件更新）
- **来源**：rustaceanvim/dap.lua:385
- **原因**：`vim.validate` 调用签名在 0.12 改变
- **处理**：等待 rustaceanvim 更新

---

## 非问题项（可忽略）

- `snacks` notifier not ready：配置中 notifier 已禁用，正常
- `dap` codelldb 路径：指向原 nvim 数据目录，nvim-012 环境下 codelldb 未重新安装，非 0.12 问题
- `rustaceanvim` rust-analyzer 找不到：未安装 rust-analyzer，与 0.12 无关
