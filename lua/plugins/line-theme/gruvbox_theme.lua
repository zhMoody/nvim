local lualine = require "lualine"

-- Gruvbox 调色板
local colors = {
  bg = "#282828",
  fg = "#ebdbb2",
  yellow = "#fabd2f",
  cyan = "#83a598",
  darkblue = "#081633",
  green = "#8ec07c",
  orange = "#fe8019",
  violet = "#a9a1e1",
  magenta = "#d3869b",
  blue = "#458588",
  red = "#cc241d",
  grey = "#928374",
  lightbg = "#3c3836",
}

local config = {
  options = {
    theme = {
      normal = {
        a = { fg = colors.bg, bg = colors.grey, gui = "bold" },
        b = { fg = colors.fg, bg = colors.lightbg },
        c = { fg = colors.grey, bg = colors.bg },
      },
      insert = {
        a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
        b = { fg = colors.fg, bg = colors.lightbg },
      },
      visual = {
        a = { fg = colors.bg, bg = colors.orange, gui = "bold" },
        b = { fg = colors.fg, bg = colors.lightbg },
      },
      replace = {
        a = { fg = colors.bg, bg = colors.red, gui = "bold" },
        b = { fg = colors.fg, bg = colors.lightbg },
      },
      command = {
        a = { fg = colors.bg, bg = colors.green, gui = "bold" },
        b = { fg = colors.fg, bg = colors.lightbg },
      },
      inactive = {
        a = { fg = colors.grey, bg = colors.bg },
        b = { fg = colors.grey, bg = colors.bg },
        c = { fg = colors.grey, bg = colors.bg },
      },
    },
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {
      {
        "filename",
        file_status = true, -- 显示只读/修改状态
        path = 1, -- 1 = 相对路径
      },
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}

lualine.setup(config)
