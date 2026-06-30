local common = require("lang.lsp-handlers")
local plugins = {}
local vue_ls_path = GetMasonPackagePath("vue-language-server")

if vue_ls_path then
  local found = vim.fs.find("typescript-plugin", {
    path = vue_ls_path,
    upward = false,
    type = "directory",
    limit = 1,
  })
  if found and #found > 0 then
    table.insert(plugins, {
      name = "@vue/typescript-plugin",
      location = found[1],
      languages = { "vue" },
    })
  end
end

return {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  init_options = { plugins = plugins },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
  end,
  settings = {
    typescript = {
      preferences = {
        autoClosingTags = true,
        importModuleSpecifierPreference = "non-relative",
        includeCompletionsForModuleExports = true,
        quotePreference = "double",
      },
      suggest = { includeCompletionsForImportStatements = true },
    },
    javascript = {
      preferences = {
        autoClosingTags = true,
        importModuleSpecifierPreference = "non-relative",
        includeCompletionsForModuleExports = true,
        quotePreference = "double",
      },
      suggest = { includeCompletionsForImportStatements = true },
    },
  },
}
