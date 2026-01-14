local ok, snacks = pcall(require, "snacks")

if ok then
  snacks.setup {
    input = { enabled = true },
    image = { enabled = true },
    terminal = { enabled = true },
    bigfile = { enabled = true },
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = {
        open = true,
        git_hl = true,
      },
      signs = {
        width = 2,
      },
      refresh = 60,
    },
    quickfile = { enabled = true },
    picker = { enabled = true },
    lazygit = {
      enabled = true,
      configure = true,
      config = {
        os = { editPreset = "nvim-remote" },
        gui = { nerdFontsVersion = "3" },
        keybinding = {
          universal = {
            edit = "o",
            open = "<c-o>",
          },
        },
      },
    },
    words = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          {
            icon = " ",
            key = "f",
            desc = "Find File",
            action = ":lua Snacks.dashboard.pick('files')",
          },
          {
            icon = " ",
            key = "n",
            desc = "New File",
            action = ":ene | startinsert",
          },
          {
            icon = " ",
            key = "o",
            desc = "Open Folder",
            action = ":NvimTreeFocus",
          },
          {
            icon = " ",
            key = "g",
            desc = "Find Text",
            action = ":lua Snacks.dashboard.pick('live_grep')",
          },
          {
            icon = " ",
            key = "r",
            desc = "Recent Files",
            action = ":lua Snacks.dashboard.pick('oldfiles')",
          },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          {
            icon = " ",
            key = "s",
            desc = "Restore Session",
            section = "session",
          },
          {
            icon = "󰒲 ",
            key = "L",
            desc = "Lazy",
            action = ":Lazy",
            enabled = package.loaded.lazy ~= nil,
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        {
          pane = 1,
          text = {
            {
              "      󰬬  ██╗     ███████╗██╗   ██╗███████╗██╗         ██╗   ██╗██████╗  󰬬 \n",
              hl = "GruvboxOrange",
            },
            {
              "      󰬬  ██║     ██╔════╝██║   ██║██╔════╝██║         ██║   ██║██╔══██╗ 󰬬 \n",
              hl = "GruvboxYellow",
            },
            {
              "      󰬬  ██║     █████╗  ██║   ██║█████╗  ██║         ██║   ██║██████╔╝ 󰬬 \n",
              hl = "GruvboxGreen",
            },
            {
              "      󰬬  ██║     ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║         ██║   ██║██╔═══╝  󰬬 \n",
              hl = "GruvboxAqua",
            },
            {
              "      󰬬  ███████╗███████╗ ╚████╔╝ ███████╗███████╗    ╚██████╔╝██║      󰬬 \n",
              hl = "GruvboxBlue",
            },
            {
              "      󰬬  ╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚══════╝     ╚═════╝ ╚═╝      󰬬 \n",
              hl = "GruvboxPurple",
            },
          },
          align = "center",
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    notifier = { enabled = false },
  }
end
