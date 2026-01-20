local common = require "lsp.languages.common"

local opts = {
  capabilities = common.capabilities,
  flags = common.flags,
  on_attach = function(_, buf)
    common.keybinding(buf)
  end,
  filetypes = {
    "html",
    "css",
    "typescriptreact",
    "javascriptreact",
    "javascript", -- 支持 .js 文件
    "vue",
    "rescript",
  },
  init_options = {
    includeLanguages = {
      javascript = "javascriptreact", -- 强制 .js 当作 jsx 处理
      rescript = "html",
    },
    showSuggestionsAsSnippets = true,
  },
}

return opts
