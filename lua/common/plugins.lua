require("lazy").setup {
  "folke/which-key.nvim",
  -- "jose-elias-alvarez/nvim-lsp-ts-utils",
  "ahmedkhalf/project.nvim",
  "theHamsta/nvim-dap-virtual-text",

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  },

  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      local common = require "lsp.languages.common"
      require("flutter-tools").setup {
        lsp = {
          capabilities = common.capabilities,
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            updateImportsOnRename = true,
          },
          on_attach = function(client, buf)
            common.disableFormat(client)
            common.keybinding(buf)
            require("common.keybindings").map_flutter_tools(buf)
          end,
        },
        ui = {
          border = "single",
          notification_style = "plugin",
        },
      }
    end,
  },
  "puremourning/vimspector",
  { "p00f/clangd_extensions.nvim", lazy = true },
  "b0o/SchemaStore.nvim",
  { "williamboman/mason.nvim", lazy = true },
  "williamboman/mason-lspconfig.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "neovim/nvim-lspconfig",
  "limitLiu/nvim-treesitter-rescript",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.install").prefer_get = true
    end,
  },
  "kyazdani42/nvim-tree.lua",
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
    },
  },
  "onsails/lspkind-nvim",
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    event = "BufReadPre",
  },
  {
    "nvim-lualine/lualine.nvim",
  },
  "numToStr/Comment.nvim",
  "windwp/nvim-autopairs",
  "tpope/vim-surround",
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  "lewis6991/gitsigns.nvim",
  "NvChad/nvim-colorizer.lua",
  "matze/vim-move",
  {
    "stevearc/conform.nvim",
    opts = {},
  },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
  },
  {
    "nvimdev/hlsearch.nvim",
    event = "BufRead",
    config = function()
      require("hlsearch").setup()
    end,
  },
  "linrongbin16/lsp-progress.nvim",
  "folke/snacks.nvim",
  "folke/trouble.nvim",
  {
    "folke/lazydev.nvim",
    ft = "lua",
  },
  { "glepnir/nerdicons.nvim", cmd = "NerdIcons" },
  {
    "echasnovski/mini.icons",
    lazy = false,
    version = false,
    config = function()
      require("mini.icons").setup()
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },
  { "nanozuki/tabby.nvim", dependencies = "echasnovski/mini.icons" },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  { "rcarriga/nvim-notify" },

  -- theme start
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "catppuccin/nvim", name = "catppuccin" },
  { "neanias/everforest-nvim", lazy = false, priority = 1000 },
  "limitLiu/zephyr-nvim",
  "RRethy/vim-illuminate",
  -- theme end
}
