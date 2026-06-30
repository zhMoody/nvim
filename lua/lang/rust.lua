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
