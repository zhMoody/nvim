local cmp_ok, cmp = pcall(require, "cmp")
local ui_ok, ui = pcall(require, "lang.lsp-ui")

if cmp_ok and ui_ok then
  cmp.setup {
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    sources = cmp.config.sources {
      { name = "nvim_lsp", group_index = 1 },
      { name = "vsnip", group_index = 2 },
      { name = "path", group_index = 3 },
    },
    mapping = require("core.keymaps").cmp(cmp),
    formatting = ui.formatting,
    sorting = {
      priority_weight = 2,
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.recently_used,
        require("clangd_extensions.cmp_scores"),
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }

  cmp.setup.cmdline("/", {
    sources = { { name = "buffer" } },
  })

  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
  })
end

local ok_cmp, m = pcall(require, "util.cmp")
if ok_cmp then
  m.cmp()
end
