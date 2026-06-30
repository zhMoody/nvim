local common = require("lang.lsp-handlers")
local opts = {
  flags = common.flags,
  filetypes = { "c", "cc", "cpp", "objc", "objcpp" },
  handlers = common.handlers,
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
    local ok, hints = pcall(require, "clangd_extensions.inlay_hints")
    if ok then
      hints.setup_autocmd()
      hints.set_inlay_hints()
    end
  end,
}
opts.capabilities = vim.tbl_deep_extend("force", common.capabilities, {
  offsetEncoding = "utf-16",
})
return opts
