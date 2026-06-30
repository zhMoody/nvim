local common = require("lang.lsp-handlers")
return {
  filetypes = { "json", "jsonc" },
  capabilities = common.capabilities,
  flags = common.flags,
  on_attach = function(client)
    common.disableFormat(client)
  end,
  settings = { json = { schemas = require("schemastore").json.schemas() } },
}
