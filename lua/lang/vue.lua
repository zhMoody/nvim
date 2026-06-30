local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
  end,
  filetypes = { "vue" },
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/vue-language-server", "--stdio" },
}
