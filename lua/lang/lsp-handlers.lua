local M = {}

M.keybinding = function(buf)
  require("core.keymaps").map_lsp(buf)
end

M.disableFormat = function(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.flags = {
  debounce_text_changes = 150,
}

M.border = {
  { "┌", "highlight" },
  { "─", "highlight" },
  { "┐", "highlight" },
  { "│", "highlight" },
  { "┘", "highlight" },
  { "─", "highlight" },
  { "└", "highlight" },
  { "│", "highlight" },
}

M.handlers = {
  ["textDocument/hover"] = vim.lsp.buf.hover { border = M.border },
  ["textDocument/signatureHelp"] = vim.lsp.buf.signature_help {
    border = M.border,
  },
}

return M
