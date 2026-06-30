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
