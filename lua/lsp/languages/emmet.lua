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
  },
}

return opts
