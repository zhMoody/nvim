return {
  -- ========================================
  -- 编辑增强（11 个）
  -- ========================================
  require("editor.autopairs"),
  require("editor.autotag"),
  require("editor.colorizer"),
  require("editor.comment"),
  require("editor.conform"),
  require("editor.hlsearch"),
  require("editor.illuminate"),
  require("editor.indent"),
  require("editor.move"),
  require("editor.render-markdown"),
  require("editor.surround"),
  require("editor.treesitter"),

  -- ========================================
  -- 文件导航（4 个）
  -- ========================================
  require("file.telescope"),
  require("file.tree"),
  require("file.trouble"),
  require("file.project"),

  -- ========================================
  -- Git（1 个）
  -- ========================================
  require("git.gitsigns"),

  -- ========================================
  -- LSP 基础设施 + Completion（9 个）
  -- ========================================
  require("lang.mason"),
  { "williamboman/mason-lspconfig.nvim", lazy = true },
  { "WhoIsSethDaniel/mason-tool-installer.nvim", lazy = true },
  { "neovim/nvim-lspconfig" },
  { "b0o/SchemaStore.nvim" },
  { "p00f/clangd_extensions.nvim", lazy = true },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "rafamadriz/friendly-snippets",
    },
  },
  { "onsails/lspkind-nvim", lazy = true },
  { "glepnir/lspsaga.nvim", event = "LspAttach" },

  -- ========================================
  -- 语言相关（2 个）
  -- ========================================
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
  },
  require("lang.flutter"),

  -- ========================================
  -- UI 显示（13 个）
  -- ========================================
  require("ui.dressing"),
  require("ui.fidget"),
  require("ui.lsp-progress"),
  require("ui.noice"),
  { "rcarriga/nvim-notify", lazy = true },
  require("ui.snacks"),
  require("ui.nerd-icons"),
  require("ui.which-key"),
  require("ui.statusline.init"),
  require("ui.tabline.init"),

  -- ========================================
  -- 新增 UI 插件（3 个）
  -- ========================================
  require("ui.xcodebuild"),
  require("ui.mini-icons"),
  require("ui.lazydev"),

  -- ========================================
  -- 调试（3 个）
  -- ========================================
  { "mfussenegger/nvim-dap", lazy = true },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  { "theHamsta/nvim-dap-virtual-text", lazy = true },
  { "puremourning/vimspector", lazy = true },

  -- ========================================
  -- 主题（只加载当前激活的那个）
  -- ========================================
  -- lazy.nvim 会在执行 colorscheme 命令时自动加载对应插件
  { "ellisonleao/gruvbox.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "neanias/everforest-nvim" },
  { "limitLiu/zephyr-nvim" },
  { "folke/tokyonight.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "rebelot/kanagawa.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "Mofiqul/dracula.nvim" },
  { "shaunsingh/nord.nvim" },
  { "sainnhe/sonokai" },
  { "navarasu/onedark.nvim" },
  { "projekt0n/github-nvim-theme", name = "github-nvim-theme" },
}
