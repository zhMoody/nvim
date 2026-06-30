local M = {}

local lspkind_ok, lspkind = pcall(require, "lspkind")
if lspkind_ok then
  lspkind.init {}
  local ok, _ = pcall(require, "cmp")
  if ok then
    M.formatting = {
      fields = { "kind", "abbr", "menu" },
      format = lspkind.cmp_format {
        mode = "symbol",
        maxwidth = 50,
        before = function(entry, vim_item)
          local source = entry.source.name
          local s = ({ nvim_lsp = "lsp" })[source]
          vim_item.menu = (s and { "[" .. s:upper():sub(1, 1) .. "]" }
            or { "[" .. source:upper():sub(1, 1) .. "]" })[1]
          return vim_item
        end,
      },
    }
  end
end

local saga_ok, lspsaga = pcall(require, "lspsaga")
if saga_ok then
  lspsaga.setup {
    ui = { border = "single" },
    symbol_in_winbar = { enable = false },
    lightbulb = { enable = false },
    diagnostic = { border_follow = false },
  }
else
  vim.notify("Failed to load lspsaga.")
end

return M
