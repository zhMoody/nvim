local common = require "lsp.languages.common"

local opts = {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
  end,
  filetypes = { "vue" },
  cmd = { vim.fn.stdpath "data" .. "/mason/bin/vue-language-server", "--stdio" },
  -- Hybrid Mode is enabled by default in newer versions of Volar
  -- No extra init_options needed
}
return opts