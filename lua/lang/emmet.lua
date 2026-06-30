local common = require("lang.lsp-handlers")
return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  on_attach = function(_, buf)
    common.keybinding(buf)
  end,
  filetypes = { "html", "css", "typescriptreact", "javascriptreact", "javascript", "vue", "rescript" },
  init_options = {
    includeLanguages = {
      javascript = "javascriptreact",
      rescript = "html",
    },
    showSuggestionsAsSnippets = true,
  },
}
