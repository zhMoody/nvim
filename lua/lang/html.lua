local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  filetypes = { "html" },
  on_attach = function(_, buf)
    common.keybinding(buf)
  end,
}
