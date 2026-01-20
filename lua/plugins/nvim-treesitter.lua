require("nvim-treesitter.install").prefer_get = true
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "vim",
    "lua",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "cpp",
    "json",
    "ocaml",
    "haskell",
    "swift",
    "zig",
    "css",
    "html",
    "dart",
    "markdown",
    "markdown_inline",
  },
  modules = {},
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      node_decremental = "<BS>",
      scope_incremental = "<TAB>",
    },
  },
  indent = {
    enable = true,
  },
}

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 99
