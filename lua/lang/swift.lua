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
