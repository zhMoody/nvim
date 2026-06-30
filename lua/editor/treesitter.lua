return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "vim", "lua", "javascript", "typescript", "tsx",
      "c", "cpp", "json", "ocaml", "haskell", "swift",
      "zig", "css", "html", "dart", "markdown", "markdown_inline", "vue",
    },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        node_decremental = "<BS>",
        scope_incremental = "<TAB>",
      },
    },
    indent = { enable = true },
  },
  config = function()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
    vim.wo.foldlevel = 99
  end,
}
