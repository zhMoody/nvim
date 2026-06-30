local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(_client, buf)
    common.disableFormat(_client)
    common.keybinding(buf)
  end,
}
